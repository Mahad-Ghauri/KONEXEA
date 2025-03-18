import 'package:flutter/material.dart';
import 'package:social_swap/controllers/Services/Authentication/authentication_controller.dart';
import 'package:social_swap/views/Authentication/login.dart';
import 'package:social_swap/views/Interface/interface.dart';

class AuthGate extends StatelessWidget {
  static const String id = 'AuthGate';
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: AuthenticationController().supabase.auth.onAuthStateChange,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        if (snapshot.hasError) {
          return Scaffold(body: Center(child: Text(snapshot.error.toString())));
        }
        final session = snapshot.hasData ? snapshot.data!.session : null;

        if (session != null) {
          return LoginPage();
        } else {
          return InterfacePage();
        }
      },
    );
  }
}
