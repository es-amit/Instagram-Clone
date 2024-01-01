import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instagram_clone/state/auth/providers/auth_state_provider.dart';
import 'package:instagram_clone/state/image_upload/helpers/image_picker_helper.dart';
import 'package:instagram_clone/state/image_upload/models/file_type.dart';
import 'package:instagram_clone/state/post_settings/providers/post_settings_provider.dart';
import 'package:instagram_clone/views/components/dialog/alert_dialog_model.dart';
import 'package:instagram_clone/views/components/dialog/log_out_dialog.dart';
import 'package:instagram_clone/views/constants/strings.dart';
import 'package:instagram_clone/views/create_new_post/create_new_post_view.dart';
import 'package:instagram_clone/views/tabs/home/home_view.dart';
import 'package:instagram_clone/views/tabs/search/search_view.dart';
import 'package:instagram_clone/views/tabs/user_posts/users_post_view.dart';

class MainView extends ConsumerStatefulWidget {
  const MainView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MainViewState();
}

class _MainViewState extends ConsumerState<MainView> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, 
      child: Scaffold(
        appBar: AppBar(
          title: const Text(Strings.appName),
          actions: [
            IconButton(
              onPressed: () async{
                // pick video first
                final videoFile = await ImagePickerHelper.pickVideoFromGallery();
                if(videoFile == null){
                  return;
                }

                // ignore: unused_result
                ref.refresh(postSettingProvider);
                
                // go to the screen to create a new post
                if(!mounted){
                  return;
                }
                Navigator.push(context, MaterialPageRoute(
                  builder: ((context) => CreateNewPostView(
                    fileToPost: videoFile, 
                    fileType: FileType.video
                  )
                )));
              }, 
              icon: const FaIcon(FontAwesomeIcons.film)
            ),
            IconButton(
              onPressed: () async{
                final imageFile = await ImagePickerHelper.pickImageFromGallery();
                if(imageFile == null){
                  return;
                }

                // ignore: unused_result
                ref.refresh(postSettingProvider);
                
                // go to the screen to create a new post
                if(!mounted){
                  return;
                }
                Navigator.push(context, MaterialPageRoute(
                  builder: ((context) => CreateNewPostView(
                    fileToPost: imageFile, 
                    fileType: FileType.image
                  )
                )));
              }, 
              icon: const Icon(Icons.add_photo_alternate_outlined)
            ),
            IconButton(
              onPressed: () async{
                final shouldLogout = await LogoutDialog()
                    .present(context)
                    .then((value) => value ?? false);
                if(shouldLogout){
                  await ref.read(authStateProvider.notifier).logOut();
                }
              }, 
              icon: const Icon(Icons.logout_outlined)
            ),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.person),
              ),
              Tab(
                icon: Icon(Icons.search),
              ),
              Tab(
                icon: Icon(Icons.home),
              )
            ]
          ),
        ),
        body: const TabBarView(
          children: [
            UserPostsView(),
            SearchView(),
            HomeView()
          ]
        ),
        
      )
    );
  }
}