import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:developer';
import 'package:social_swap/consts.dart';
import 'package:social_swap/controllers/api_services.dart';
import 'package:social_swap/utils/theme.dart';
import 'package:social_swap/views/Authentication/auth_gate.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Supabase.initialize(url: url, anonKey: anonKey).then((value) {
      log("Supabase Initialized");

      runApp(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (context) => ApiServices()),
          ],
          child: const MainApp(),
        ),
      );
    });
  } catch (error, stackTrace) {
    log("Error initializing Supabase: ${error.toString()}");
    log(stackTrace.toString());
  }
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
