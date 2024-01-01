

import 'package:flutter/material.dart';
import 'package:instagram_clone/state/posts/models/post.dart';

class PostImageView extends StatelessWidget {
  final Post post;
  const PostImageView({super.key,required this.post});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: post.aspectRatio,
      child: Image.network(
        post.fileUrl,
        loadingBuilder: (context,child,loadingProgess){
          if(loadingProgess == null){
            return child;
          }
          return const Center(
            child: CircularProgressIndicator()
          );
        },
      ),
    );
  }
}