

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instagram_clone/state/constants/firebase_collection_names.dart';
import 'package:instagram_clone/state/constants/firebase_field_names.dart';
import 'package:instagram_clone/state/posts/models/post.dart';

final allPostProvider = StreamProvider.autoDispose<Iterable<Post>>(
  (ref){
    
    final controller = StreamController<Iterable<Post>>();

    final sub = FirebaseFirestore
    .instance
    .collection(FirebaseCollectionName.posts)
    .orderBy(FirebaseFieldName.createdAt, descending: true)
    .snapshots()
    .listen((snapshot) { 
      final posts = snapshot.docs.map((doc) => Post(
        postId: doc.id, 
        json: doc.data()
        )
      );
      controller.sink.add(posts);
    });

    ref.onDispose(() {
      sub.cancel();
      controller.close();
    });

    return controller.stream;
  }
);