// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:social_swap/views/Interface/interface.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthenticationController {
  //  Instance for supabase client
  final supabase = Supabase.instance.client;

  //  Sign up method
  Future<bool> signUpWithEmailPassword(
    String email,
    String password,
    BuildContext context,
  ) async {
    try {
      final response = await supabase.auth.signUp(
        email: email,
        password: password,
      );

      if (response.user != null) {
        if (context.mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const InterfacePage()),
          );
        }
        return true;
      }
      return false;
    } catch (error) {
      log('Sign up error: $error');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              error.toString().contains('already registered')
                  ? 'Email already registered'
                  : 'Sign up failed. Please try again.',
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
      return false;
    }
  }

  //  Sign in method
  Future<bool> signInWithEmailPassword(
    String email,
    String password,
    BuildContext context,
  ) async {
    try {
      final response = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user != null) {
        log('Sign in successful: ${response.user?.email}');
        if (context.mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const InterfacePage()),
          );
        }
        return true;
      }
      return false;
    } catch (error) {
      log('Sign in error: $error');
      if (context.mounted) {
        String errorMessage = 'Invalid email or password';
        if (error.toString().contains('Invalid login credentials')) {
          errorMessage = 'Invalid email or password';
        } else if (error.toString().contains('Email not confirmed')) {
          errorMessage = 'Please verify your email first';
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
      return false;
    }
  }

  //  Sign out method
  Future<bool> signOutCurrentSession() async {
    try {
      await supabase.auth.signOut();
      return true;
    } catch (error) {
      log('Sign out error: $error');
      return false;
    }
  }

  //  Get user email from current session
  String? getUserEmail() {
    return supabase.auth.currentUser?.email;
  }

  bool isUserLoggedIn() {
    return supabase.auth.currentUser != null;
  }
}
