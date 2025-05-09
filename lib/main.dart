import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_swap/Controllers/Services/Feed%20Database/feed_services.dart';
import 'package:social_swap/Controllers/Services/P-Hub%20Interface/interface_controllers.dart';
import 'package:social_swap/Controllers/Services/API/Thrift%20Store/phub_api_services.dart';
import 'package:social_swap/Controllers/Services/Cart%20Services/cart_service.dart';
import 'package:social_swap/Controllers/Services/Chat/chat_services.dart';
import 'dart:developer';
import 'package:social_swap/Utils/consts.dart';
import 'package:social_swap/controllers/Services/API/News API/api_services.dart';
import 'package:social_swap/controllers/Services/API/Chatbot/chatbot_services.dart';
import 'package:social_swap/firebase_options.dart';
import 'package:social_swap/utils/theme.dart';
import 'package:social_swap/views/Auth Gate/auth_gate.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //  initialize firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform)
      .then((value) {
    log("Firebase Initialization Completed");
    Supabase.initialize(url: url, anonKey: anonKey).then((value) {
      log("Supabase Initialized");

      runApp(
        // Providers
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (context) => ApiServices()),
            ChangeNotifierProvider(create: (context) => PHubApiServices()),
            ChangeNotifierProvider(create: (context) => FeedServices()),
            ChangeNotifierProvider(create: (context) => CartServices()),
            ChangeNotifierProvider(create: (context) => ChatServices()),
            ChangeNotifierProvider(
              create: (context) => ChatbotController(),
            ),
            ChangeNotifierProvider(
              create: (context) => InterfaceController(),
            ),
          ],
          child: const MainApp(),
        ),
      );
    }).onError((error, stackTrace) {
      log(error.toString());
      log(stackTrace.toString());
    });
  }).onError((error, stackTrace) {
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
      home: const AuthGate(),
    );
  }
}
