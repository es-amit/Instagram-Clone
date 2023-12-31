
import 'dart:collection' show MapView;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:instagram_clone/state/constants/firebase_field_names.dart';
import 'package:instagram_clone/state/posts/typeddefs/post_id.dart';
import 'package:instagram_clone/state/posts/typeddefs/user_id.dart';

@immutable

class CommentPayload extends MapView<String, dynamic>{

  CommentPayload({
    required UserId fromUserId,
    required PostId onPostId,
    required String comment,
  }): super({
    FirebaseFieldName.userId: fromUserId,
    FirebaseFieldName.comment: comment,
    FirebaseFieldName.postId: onPostId,
    FirebaseFieldName.createdAt: FieldValue.serverTimestamp()
  });


  
}