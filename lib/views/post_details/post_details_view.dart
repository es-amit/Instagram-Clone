// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instagram_clone/enums/date_sorting.dart';
import 'package:instagram_clone/state/comments/models/post_comments_request.dart';
import 'package:instagram_clone/state/posts/models/post.dart';
import 'package:instagram_clone/state/posts/providers/can_current_user_delete_post_provider.dart';
import 'package:instagram_clone/state/posts/providers/delete_post_provider.dart';
import 'package:instagram_clone/state/posts/providers/specific_post_with_comments.dart';
import 'package:instagram_clone/views/components/animations/error_animation_view.dart';
import 'package:instagram_clone/views/components/animations/loading_animation_view.dart';
import 'package:instagram_clone/views/components/animations/small_error_animation_view.dart';
import 'package:instagram_clone/views/components/comment/compact_comment_column.dart';
import 'package:instagram_clone/views/components/dialog/alert_dialog_model.dart';
import 'package:instagram_clone/views/components/dialog/delete_dialog.dart';
import 'package:instagram_clone/views/components/like_button.dart';
import 'package:instagram_clone/views/components/likes_count_view.dart';
import 'package:instagram_clone/views/components/post/post_date_view.dart';
import 'package:instagram_clone/views/components/post/post_display_name_and_message.dart';
import 'package:instagram_clone/views/components/post/post_image_or_video_view.dart';
import 'package:instagram_clone/views/constants/strings.dart';
import 'package:instagram_clone/views/post_comments/post_comment_view.dart';
import 'package:share_plus/share_plus.dart';

class PostDetailsView extends ConsumerStatefulWidget {
  final Post post;
  const PostDetailsView({super.key, required this.post});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _PostDetailsViewState();
}

class _PostDetailsViewState extends ConsumerState<PostDetailsView> {
  @override
  Widget build(BuildContext context) {
    final request = RequestForPostAndComments(
        postId: widget.post.postId,
        limit: 3,
        dateSorting: DateSorting.oldestOnTop,
        sortByCreatedAt: true);

    final postWithComments =
        ref.watch(specificPostWithCommentsProvider(request));
    // can we delete post

    final canDeletePost =
        ref.watch(canCurrentUserDeletePostProvider(widget.post));

    return Scaffold(
      appBar: AppBar(
        title: const Text(Strings.postDetails),
        centerTitle: true,
        actions: [
          postWithComments.when(data: (postWithComments) {
            return IconButton(
                onPressed: () {
                  final url = postWithComments.post.fileUrl;
                  Share.share(url, subject: Strings.checkOutThisPost);
                },
                icon: const Icon(Icons.share));
          }, error: (error, stackTrace) {
            return const SmallErrorAnimationView();
          }, loading: () {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }),
          // delete button or no delete button if user cannot delete this post
          if (canDeletePost.value ?? false)
            IconButton(
                onPressed: () async {
                  final shouldDeletePost = await const DeleteDialog(
                          titleOfObjectToDelete: Strings.post)
                      .present(context)
                      .then((shouldDelete) => shouldDelete ?? false);

                  if (shouldDeletePost) {
                    await ref
                        .read(deletePostProvider.notifier)
                        .deletePost(post: widget.post);
                    if (mounted) {
                      Navigator.of(context).pop();
                    }
                  }
                },
                icon: const Icon(Icons.delete))
        ],
      ),
      body: postWithComments.when(data: (postWithComments) {
        final postId = postWithComments.post.postId;
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              PostImageOrVideoView(post: postWithComments.post),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // likebutton if post allow
                  if (postWithComments.post.allowsLikes)
                    LikeButton(postId: postId),

                  // comment button if post allow
                  if (postWithComments.post.allowsComments)
                    IconButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: ((context) =>
                                      PostCommentView(postId: postId))));
                        },
                        icon: const Icon(Icons.mode_comment_outlined))
                ],
              ),
              // post details show divider at the bottom
              PostDisplayNameAndMessageView(post: postWithComments.post),
              PostDateView(dateTime: postWithComments.post.createdAt),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Divider(
                  color: Colors.white70,
                ),
              ),
              CompactCommentColumn(comments: postWithComments.comments),

              // display like count
              if (postWithComments.post.allowsLikes)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      LikesCountView(postId: postId),
                    ],
                  ),
                ),

              // add spacing to bottom of screen
              const SizedBox(
                height: 100,
              )
            ],
          ),
        );
      }, error: (error, stackTrace) {
        return const ErrorAnimationView();
      }, loading: () {
        return const LoadingAnimationView();
      }),
    );
  }
}
