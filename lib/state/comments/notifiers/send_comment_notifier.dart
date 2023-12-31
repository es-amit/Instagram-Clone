

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instagram_clone/state/comments/models/comment_payload.dart';
import 'package:instagram_clone/state/constants/firebase_collection_names.dart';
import 'package:instagram_clone/state/image_upload/typedets/is_loading.dart';
import 'package:instagram_clone/state/posts/typeddefs/post_id.dart';
import 'package:instagram_clone/state/posts/typeddefs/user_id.dart';

class SendCommentNotifier extends StateNotifier<IsLoading>{

  SendCommentNotifier(): super(false);

  set isLoading(bool value) => state = value;


  Future<bool> sendComment({
    required UserId fromUserId,
    required PostId onPostId,
    required String comment,
  }) async{

    isLoading = true;
    final payload = CommentPayload(
        fromUserId: fromUserId, 
        onPostId: onPostId, 
        comment: comment
      );
    try{

      await FirebaseFirestore
        .instance
        .collection(
          FirebaseCollectionName.comments
        ).add(payload);
      return true;
    }
    catch(e){
      return false;
    }
    finally{
      isLoading = false;
    }
  }
}