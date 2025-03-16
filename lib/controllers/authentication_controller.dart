import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:social_swap/views/Interface/interface.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthenticationController {
  //  Instance for supabase client
  final supabase = Supabase.instance.client;
  //  Sign up method
  Future<void> signUpWithEmailPassword(
    String email,
    String password,
    BuildContext context,
  ) async {
    try {
      await supabase.auth.signUp(email: email, password: password).then((
        value,
      ) {
        Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (context) => const InterfacePage()));
      });
    } catch (error) {
      log(error.toString());
    }
  }

  //  Sign in method
  Future<void> signInWithEmailPassword(String email, String password) async {
    try {
      final response = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.session != null) {
        log("User signed in");
      } else {
        log("User not signed in");
      }
    } catch (error) {
      log(error.toString());
    }
  }

  //  Sign out method
  Future<void> signOutCurrentSession() async {
    try {
      await supabase.auth.signOut();
    } catch (error) {
      log(error.toString());
    }
  }

  //  Get user email from current session
  String? getUserEmail() {
    if (supabase.auth.currentUser != null) {
      return supabase.auth.currentUser!.email;
    } else {
      return null;
    }
  }
}
