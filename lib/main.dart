import 'package:flutter/material.dart';
import 'package:social_swap/consts.dart';
import 'package:social_swap/utils/theme.dart';
import 'package:social_swap/views/Authentication/auth_gate.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(url: url, anonKey: anonKey).then((value) {
    runApp(const MainApp());
  });
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(theme: lightMode, home: AuthGate());
  }
}
