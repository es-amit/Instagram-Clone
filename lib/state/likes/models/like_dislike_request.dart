import 'package:flutter/foundation.dart' show immutable;
import 'package:instagram_clone/state/posts/typeddefs/post_id.dart';
import 'package:instagram_clone/state/posts/typeddefs/user_id.dart';

@immutable
class LikeDislikeRequest {
  final PostId postId;
  final UserId likedBy;

  const LikeDislikeRequest({
    required this.postId, 
    required this.likedBy
  });
}
