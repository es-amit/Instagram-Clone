import 'dart:collection' show MapView;

import 'package:flutter/foundation.dart' show immutable;
import 'package:instagram_clone/state/constants/firebase_field_names.dart';
import 'package:instagram_clone/state/posts/typeddefs/user_id.dart';
@immutable

class UserInfoPlayload extends MapView<String,String> {

  UserInfoPlayload({
    required UserId userId,
    required String? displayName,
    required String? email,
  }) : super({
    FirebaseFieldName.userId: userId,
    FirebaseFieldName.displayName: displayName ?? '',
    FirebaseFieldName.email: email ?? '',
  });
  
}