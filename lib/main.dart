import 'package:flutter/material.dart';
import 'dart:developer';
import 'package:social_swap/consts.dart';
import 'package:social_swap/utils/routes.dart';
import 'package:social_swap/utils/theme.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  const url = "https://gttdwnnthusaqvujxoll.supabase.co";
  const annonKey =
      "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imd0dGR3bm50aHVzYXF2dWp4b2xsIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDE5Nzk2MzAsImV4cCI6MjA1NzU1NTYzMH0.tN5HjhRD6An99un_T9FIAVcCHcLNfmwmgXEsKGIV7VA";
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(url: url, anonKey: anonKey)
      .then((value) {
        log("Supabase Initiallized");
        runApp(const MainApp());
      })
      .onError((error, StackTrace) {
        log(error.toString());
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
      initialRoute: Routes.login,
      onGenerateRoute: Routes.generateRoute,
    );
  }
}
