

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instagram_clone/state/comments/notifiers/delete_comment_notifier.dart';
import 'package:instagram_clone/state/image_upload/typedets/is_loading.dart';

final deleteCommentProvider = StateNotifierProvider<DeleteCommentStateNotifer,IsLoading>(
  (_) => DeleteCommentStateNotifer()
);
