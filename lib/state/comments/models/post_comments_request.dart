
import 'package:flutter/foundation.dart' show immutable;
import 'package:instagram_clone/enums/date_sorting.dart';
import 'package:instagram_clone/state/posts/typeddefs/post_id.dart';
@immutable

class RequestForPostAndComments {
  final PostId postId;
  final bool sortByCreatedAt;
  final DateSorting dateSorting;
  final int? limit;

  const RequestForPostAndComments({
    required this.postId, 
    this.sortByCreatedAt = true, 
    this.dateSorting = DateSorting.newestOnTop, 
    // ignore: avoid_init_to_null
    this.limit = null
  });

  @override
  bool operator ==(covariant RequestForPostAndComments other) =>
    postId == other.postId &&
    sortByCreatedAt == other.sortByCreatedAt &&
    dateSorting == other.dateSorting &&
    limit == other.limit;
    
  @override
  int get hashCode => Object.hashAll(
    [
      postId,
      sortByCreatedAt,
      dateSorting,
      limit
    ]
  );
}