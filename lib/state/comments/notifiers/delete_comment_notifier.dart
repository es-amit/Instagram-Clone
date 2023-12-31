

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instagram_clone/state/comments/typedefs/comment_id.dart';
import 'package:instagram_clone/state/constants/firebase_collection_names.dart';
import 'package:instagram_clone/state/image_upload/typedets/is_loading.dart';

class DeleteCommentStateNotifer extends StateNotifier<IsLoading>{

  DeleteCommentStateNotifer(): super(false);

  set isLoading(bool value) => state = value;

  Future<bool> deleteComment({
    required CommentId commentId
  }) async{
    try{
      isLoading =true;
      
      final query = FirebaseFirestore
      .instance
      .collection(FirebaseCollectionName.comments)
      .where(
        FieldPath.documentId,
        isEqualTo: commentId
      )
      .limit(1)
      .get();

      await query.then((query) async{

        for(final doc in query.docs){
          await doc.reference.delete();
        }
      });
      
      return true;
    }
    catch(_){
      return false;
    }
    finally{
      isLoading =false;
    }

  }
}