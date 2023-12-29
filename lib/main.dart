import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instagram_clone/firebase_options.dart';
import 'package:instagram_clone/state/auth/providers/auth_state_provider.dart';
import 'dart:developer' as devtools show log;

import 'package:instagram_clone/state/auth/providers/is_logged_in_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProviderScope(child: MyApp()));
}

extension Log on Object {
  void log() => devtools.log(toString());
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
            builder: (context,ref,child){
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


// for when you are not logged in
class LoginView extends ConsumerWidget {
  const LoginView({
    super.key,
  });

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("login view"),
      ),
      body: Column(
        children: [
          TextButton(
              onPressed: () {
                ref.read(authStateProvider.notifier).loginWithGoogle();
              },
              child: const Text('Sign in With Google')),
          TextButton(
              onPressed: ()  {
                ref.read(authStateProvider.notifier).loginWithFacebook();
                print('signed in with facebook');
                
              },
              child: const Text('Sign in With Facebook')),
        ],
      ),
    );
  }
}
