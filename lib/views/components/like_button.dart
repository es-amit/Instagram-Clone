import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instagram_clone/state/auth/providers/user_id_provider.dart';
import 'package:instagram_clone/state/likes/models/like_dislike_request.dart';
import 'package:instagram_clone/state/likes/providers/has_like_post_provider.dart';
import 'package:instagram_clone/state/likes/providers/likes_dislike_post_provider.dart';
import 'package:instagram_clone/state/posts/typeddefs/post_id.dart';
import 'package:instagram_clone/views/components/animations/small_error_animation_view.dart';

class LikeButton extends ConsumerWidget {
  final PostId postId;
  const LikeButton( {super.key,required this.postId});

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final hasLiked = ref.watch(hasLikedPostProvider(postId));
    return hasLiked.when(
      data: (hasLiked){

        return IconButton(
          onPressed: (){
            final userId = ref.read(userIdProvider);
            if(userId == null){
              return;
            }
            final likeRequest = LikeDislikeRequest(
              postId: postId, 
              likedBy: userId
            );
            ref.read(likeDislikePostProvider(likeRequest));
          }, 
          icon: hasLiked?
           const Icon(Icons.favorite_rounded ,color: Colors.redAccent,)
           : const Icon(Icons.favorite_outline_rounded)
        );

      }, 
      error: (error,stackTrace){
        return const SmallErrorAnimationView();
      }, 
      loading: (){
        return const Center(
          child: CircularProgressIndicator(),
        );
      }
    );
  }
}