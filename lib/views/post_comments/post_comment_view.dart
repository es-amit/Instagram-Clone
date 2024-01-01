import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instagram_clone/state/auth/providers/user_id_provider.dart';
import 'package:instagram_clone/state/comments/models/post_comments_request.dart';
import 'package:instagram_clone/state/comments/providers/post_comments_provider.dart';
import 'package:instagram_clone/state/comments/providers/send_comment_provider.dart';
import 'package:instagram_clone/state/posts/typeddefs/post_id.dart';
import 'package:instagram_clone/views/components/animations/empty_contents_with_text_animation_view.dart';
import 'package:instagram_clone/views/components/animations/error_animation_view.dart';
import 'package:instagram_clone/views/components/animations/loading_animation_view.dart';
import 'package:instagram_clone/views/components/comment/comment_tile.dart';
import 'package:instagram_clone/views/constants/strings.dart';
import 'package:instagram_clone/views/extensions/dismiss_keyboad.dart';

class PostCommentView extends HookConsumerWidget {
  final PostId postId;
  const PostCommentView({
    super.key,
    required this.postId
  });

  @override
  Widget build(BuildContext context,WidgetRef ref) {

    final commentController = useTextEditingController();
    
    final hasText = useState(false);

    final request = useState(
      RequestForPostAndComments(
        postId: postId, 
      ),
    );

    final comments = ref.watch(postCommentProvider(request.value));

    useEffect(() {

      commentController.addListener(() {
        hasText.value = commentController.text.isNotEmpty;
      });
      return () {};

    },[commentController]);

    return Scaffold(
      appBar: AppBar(
        title: const Text(Strings.comments),
        actions: [
          IconButton(
            onPressed: hasText.value ? (){

              _submitCommentWithController(commentController, ref);
              
            } : null, 
            icon: const Icon(Icons.send)
          )
        ],
      ),
      body: SafeArea(
        child: Flex(
          direction: Axis.vertical,
          children: [
            Expanded(
              flex: 4,
              child: comments.when(
                data: (comments){
                  if(comments.isEmpty){
                    return const SingleChildScrollView(
                      child: EmptyContentsWithTextAnimationView(text: Strings.noCommentsYet ),
                    );
                  }
                  else{
                    return RefreshIndicator(
                       
                      onRefresh: (){
                        // ignore: unused_result
                        ref.refresh(postCommentProvider(request.value));
                        return Future.delayed(const Duration(seconds: 1));
                      },
                      child: ListView.builder(
                        padding: const EdgeInsets.all(8.0),
                        itemCount: comments.length,
                        itemBuilder: ((context, index) {
                          return CommentTile(
                            comment: comments.elementAt(index)
                          );
                        })
                      ),

                    );
                  }
                  
                }, 
                error: (error,stackTrace){
                  return const ErrorAnimationView();
                }, 
                loading: (){
                  return const LoadingAnimationView();
                }
              )
            ),
            Expanded(
              flex: 1,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: TextField(
                  controller: commentController,
                  textInputAction: TextInputAction.send,
                  decoration:const InputDecoration(
                    labelText: Strings.writeYourCommentHere,
                    border: OutlineInputBorder()
                  ),
                  onSubmitted: (commment){
                    if(commment.isNotEmpty){
                      _submitCommentWithController(commentController, ref);
                    }
                  },
                ),
              )
            )
          ],
        )
      ),
    );
  }


  Future<void> _submitCommentWithController(
    TextEditingController controller,
    WidgetRef ref
  ) async{

    final userId = ref.read(userIdProvider);
    if(userId == null){
      return;
    }
    final isSent = await ref.read(sendCommentProvider.notifier).sendComment(
      fromUserId: userId, 
      onPostId: postId, 
      comment: controller.text
    );

    if(isSent){
      controller.clear();
      dismissKeyboard();
    }
  }
}