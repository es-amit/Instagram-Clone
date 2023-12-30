import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instagram_clone/firebase_options.dart';
import 'package:instagram_clone/state/auth/providers/auth_state_provider.dart';
import 'package:instagram_clone/state/auth/providers/is_logged_in_provider.dart';
import 'package:instagram_clone/state/providers/is_loading_provider.dart';
import 'package:instagram_clone/views/components/loading/loading_screen.dart';
import 'package:instagram_clone/views/login/login_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProviderScope(child: MyApp()));
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      darkTheme: ThemeData(
          brightness: Brightness.dark,
          primarySwatch: Colors.blueGrey,
          indicatorColor: Colors.blueGrey),
      theme: ThemeData(brightness: Brightness.dark, primarySwatch: Colors.blue),
      themeMode: ThemeMode.dark,
      debugShowCheckedModeBanner: false,
      home: Consumer(
        builder: ((context, ref, child) {
          LoadingScreen loadingScreen =LoadingScreen.instance();

          ref.listen<bool>(
            isLoadingProvider, 
            (_, isLoading) { 
              if(isLoading){
                loadingScreen.show(context: context);
              }
              else{
                loadingScreen.hide();
              }
            }
          );
          final isLoggedIn = ref.watch(isLoggedInProvider);
          if(isLoggedIn){
            return const MainView();
          }
          else{
            return const LoginView();
          }
        })
      ),
    );
  }
}

// for when you are already logged in
class MainView extends StatelessWidget {
  const MainView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Main View"),
      ),
      body: Column(
        children: [
          Consumer(
            builder: (_,ref,child){
              return TextButton(
              onPressed: () async{
                await ref.read(authStateProvider.notifier).logOut();
            
              }, 
              child: const Text("Log out")
              );
            },
            
          )
        ],
      ),
    );
  }
}

