

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instagram_clone/state/auth/providers/auth_state_provider.dart';
import 'package:instagram_clone/state/image_upload/providers/image_uploader_provider.dart';
import 'package:instagram_clone/state/image_upload/typedets/is_loading.dart';

final isLoadingProvider = Provider<IsLoading>(
  (ref){
    final authState = ref.watch(authStateProvider);
    final isUploadingImage = ref.watch(imageUploaderProvider);
    return authState.isLoading || isUploadingImage;
  }
);