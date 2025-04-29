// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:social_swap/controllers/Services/Authentication/authentication_controller.dart';
import 'package:social_swap/controllers/input_controllers.dart';
import 'package:social_swap/views/Authentication/signup.dart';
import 'package:social_swap/views/components/auth_button.dart';
import 'package:social_swap/views/components/my_form_field.dart';
// import 'package:social_swap/views/components/logo.dart';

class LoginPage extends StatefulWidget {
  static const String id = 'LoginPage';
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final AuthenticationController _authController = AuthenticationController();
  final InputControllers _inputControllers = InputControllers();

  @override
  void dispose() {
    _inputControllers.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _inputControllers.loading = true;
      });

      try {
        final success = await _authController.signInWithEmailPassword(
          _inputControllers.emailController.text,
          _inputControllers.passwordController.text,
          context,
        );

        if (!success && mounted) {
          setState(() {
            _inputControllers.loading = false;
          });
        }
      } catch (error) {
        if (mounted) {
          setState(() {
            _inputControllers.loading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("An unexpected error occurred. Please try again."),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: [
          // Dark Overlay for better contrast
          Positioned.fill(
            child: Container(color: Colors.black.withOpacity(0.35)),
          ),

          // Login Card
          SingleChildScrollView(
            child: SizedBox(
              height: height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: width * 0.05,
                        vertical: height * 0.02,
                      ),
                      child: Column(
                        children: [
                          //--------------Logo--------------//
                          // Padding(
                          //   padding: const EdgeInsets.only(bottom: 30),
                          //   child: Column(
                          //     children: [
                          //       Icon(
                          //         FontAwesomeIcons.infinity,
                          //         size: height * 0.09,
                          //         color: Theme.of(context).colorScheme.primary,
                          //       ),
                          //       // const SizedBox(height: 5),
                          //       Text(
                          //         '  Social Swap',
                          //         style: GoogleFonts.italiana(
                          //           fontSize: 32,
                          //           fontWeight: FontWeight.w700,
                          //           color:
                          //               Theme.of(context).colorScheme.tertiary,
                          //           letterSpacing: 1.5,
                          //         ),
                          //       ),
                          //     ],
                          //   ),
                          // ),
                          // ignore: avoid_unnecessary_containers
                          Container(
                            //-------------Underglow Card--------------//
                            // decoration: BoxDecoration(
                            //   borderRadius: BorderRadius.circular(25),
                            //   boxShadow: [
                            //     // Simple underglow effect
                            //     BoxShadow(
                            //       color: Theme.of(
                            //         context,
                            //       ).colorScheme.primary.withOpacity(0.6),
                            //       blurRadius: 8,
                            //       spreadRadius: 0,
                            //       offset: const Offset(0, 0),
                            //     ),
                            //   ],
                            // ),
                            child: Card(
                              elevation: 10,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                              color: Theme.of(context).colorScheme.surface,
                              child: Center(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: width * 0.05,
                                    vertical: height * 0.05,
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Log In",
                                        style: TextStyle(
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.tertiary,
                                          fontWeight: FontWeight.bold,
                                          fontSize: height * 0.045,
                                          letterSpacing: 2,
                                          fontFamily:
                                              GoogleFonts.italiana().fontFamily,
                                          shadows: const [
                                            Shadow(
                                              color: Colors.black26,
                                              offset: Offset(2, 2),
                                              blurRadius: 4,
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: height * 0.01),
                                      Text(
                                        "Welcome back! You've been missed",
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .tertiary
                                              .withOpacity(0.9),
                                          fontSize: height * 0.018,
                                          fontFamily:
                                              GoogleFonts.urbanist().fontFamily,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                      SizedBox(height: height * 0.035),
                                      Form(
                                        key: _formKey,
                                        child: Column(
                                          children: [
                                            MyFormField(
                                              hintText: "Email",
                                              hintStyle: TextStyle(
                                                color: Theme.of(
                                                  context,
                                                ).colorScheme.tertiary,
                                              ),
                                              prefixIcon: Icons.alternate_email,
                                              controller: _inputControllers
                                                  .emailController,
                                              keyboardType:
                                                  TextInputType.emailAddress,
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Please enter your email';
                                                }
                                                if (!value.contains('@')) {
                                                  return 'Please enter a valid email';
                                                }
                                                return null;
                                              },
                                            ),
                                            SizedBox(height: height * 0.02),
                                            MyFormField(
                                              hintText: "Password",
                                              hintStyle: TextStyle(
                                                color: Theme.of(
                                                  context,
                                                ).colorScheme.tertiary,
                                              ),
                                              prefixIcon: Icons.lock,
                                              controller: _inputControllers
                                                  .passwordController,
                                              obscureText: true,
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Please enter your password';
                                                }
                                                if (value.length < 6) {
                                                  return 'Password must be at least 6 characters';
                                                }
                                                return null;
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: height * 0.02),
                                      AuthButton(
                                        onPressed: _handleLogin,
                                        text: "Log In",
                                        textStyle: TextStyle(
                                          fontFamily:
                                              GoogleFonts.outfit().fontFamily,
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.surface,
                                          fontSize: 19,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        isLoading: _inputControllers.loading,
                                      ),
                                      SizedBox(height: height * 0.02),
                                      Row(
                                        spacing: 4.0,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'Don\'t have an account?',
                                            style: TextStyle(
                                              color: Theme.of(
                                                context,
                                              ).colorScheme.tertiary,
                                            ),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).push(
                                                _elegantRoute(
                                                    const SignUpPage()),
                                              );
                                            },
                                            child: Text(
                                              'Sign Up',
                                              style: TextStyle(
                                                color: Theme.of(
                                                  context,
                                                ).colorScheme.primary,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  PageRouteBuilder _elegantRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var fadeAnimation = Tween<double>(begin: 0, end: 1).animate(animation);
        var scaleAnimation = Tween<double>(begin: 0.95, end: 1).animate(
          CurvedAnimation(parent: animation, curve: Curves.easeOutExpo),
        );
        return FadeTransition(
          opacity: fadeAnimation,
          child: ScaleTransition(scale: scaleAnimation, child: child),
        );
      },
      transitionDuration: const Duration(milliseconds: 500),
    );
  }
}
