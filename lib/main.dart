import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:developer';
import 'package:social_swap/consts.dart';
import 'package:social_swap/controllers/Services/API/api_services.dart';
import 'package:social_swap/controllers/Services/Database/feed_services.dart';
import 'package:social_swap/firebase_options.dart';
import 'package:social_swap/utils/theme.dart';
import 'package:social_swap/views/Authentication/auth_gate.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //  initialize firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform)
      .then((value) {
        log("Firebase Initialization Completed");
        Supabase.initialize(url: url, anonKey: anonKey)
            .then((value) {
              log("Supabase Initialized");

              runApp(
                MultiProvider(
                  providers: [
                    ChangeNotifierProvider(create: (context) => ApiServices()),
                    ChangeNotifierProvider(create: (context) => FeedServices()),
                  ],
                  child: const MainApp(),
                ),
              );
            })
            .onError((error, stackTrace) {
              log(error.toString());
              log(stackTrace.toString());
            });
      })
      .onError((error, stackTrace) {
        log(error.toString());
        log(stackTrace.toString());
      });
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Social Swap',
      theme: lightMode,
      home: AuthGate(),
    );
  }
}
