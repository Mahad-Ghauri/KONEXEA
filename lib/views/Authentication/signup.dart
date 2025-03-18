import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:social_swap/controllers/authentication_controller.dart';
import 'package:social_swap/controllers/input_controllers.dart';
import 'package:social_swap/views/Authentication/login.dart';
import 'package:social_swap/views/components/auth_button.dart';
import 'package:social_swap/views/components/my_form_field.dart';

class SignUpPage extends StatefulWidget {
  static const String id = 'SignUpPage';
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final AuthenticationController _authController = AuthenticationController();
  final InputControllers _inputControllers = InputControllers();

  @override
  void dispose() {
    _inputControllers.dispose();
    super.dispose();
  }

  Future<void> _handleSignUp() async {
    if (_formKey.currentState!.validate()) {
      if (_inputControllers.passwordController.text !=
          _inputControllers.confirmPasswordController.text) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Passwords do not match')));
        return;
      }
      await _authController
          .signUpWithEmailPassword(
            _inputControllers.emailController.text,
            _inputControllers.passwordController.text,
            context,
          )
          .then((_) {
            Navigator.of(context).pushReplacement(_elegantRoute(LoginPage()));
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SingleChildScrollView(
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
                  child: Card(
                    elevation: 10,
                    shadowColor: Theme.of(
                      context,
                    ).colorScheme.primary.withOpacity(0.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    color: Theme.of(context).colorScheme.primary,
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
                              "Sign Up",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: height * 0.045,
                                letterSpacing: 2,
                                fontFamily: GoogleFonts.italiana().fontFamily,
                                shadows: [
                                  Shadow(
                                    color: Colors.black26,
                                    offset: const Offset(2, 2),
                                    blurRadius: 4,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: height * 0.01),
                            Text(
                              "Welcome to Social Swap",
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.9),
                                fontSize: height * 0.018,
                                fontFamily: GoogleFonts.urbanist().fontFamily,
                                letterSpacing: 0.5,
                              ),
                            ),
                            SizedBox(height: height * 0.035),
                            Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  MyFormField(
                                    hintText: "Enter your name",
                                    prefixIcon: Icons.person,
                                    controller:
                                        _inputControllers.nameController,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter your name';
                                      }
                                      return null;
                                    },
                                    onChanged: (value) => {setState(() {})},
                                  ),
                                  SizedBox(height: height * 0.02),
                                  MyFormField(
                                    hintText: "Email",
                                    prefixIcon: Icons.alternate_email,
                                    controller:
                                        _inputControllers.emailController,
                                    keyboardType: TextInputType.emailAddress,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter your email';
                                      }
                                      if (!value.contains('@')) {
                                        return 'Please enter a valid email';
                                      }
                                      return null;
                                    },
                                    onChanged: (value) => {setState(() {})},
                                  ),
                                  SizedBox(height: height * 0.02),
                                  MyFormField(
                                    hintText: "Password",
                                    prefixIcon: Icons.lock,
                                    controller:
                                        _inputControllers.passwordController,
                                    obscureText: true,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter your password';
                                      }
                                      if (value.length < 6) {
                                        return 'Password must be at least 6 characters';
                                      }
                                      return null;
                                    },
                                    onChanged: (value) => {setState(() {})},
                                  ),
                                  SizedBox(height: height * 0.02),
                                  MyFormField(
                                    hintText: "Confirm Password",
                                    prefixIcon: Icons.lock,
                                    controller:
                                        _inputControllers
                                            .confirmPasswordController,
                                    obscureText: true,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please confirm your password';
                                      }
                                      if (value !=
                                          _inputControllers
                                              .passwordController
                                              .text) {
                                        return 'Passwords do not match';
                                      }
                                      return null;
                                    },
                                    onChanged: (value) => {setState(() {})},
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: height * 0.035),
                            AuthButton(
                              onPressed: _handleSignUp,
                              text: "Sign Up",
                            ),
                            SizedBox(height: height * 0.025),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Already have an account?",
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.9),
                                    fontSize: height * 0.017,
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pushReplacement(
                                      _elegantRoute(LoginPage()),
                                    );
                                  },
                                  child: Text(
                                    "Log In",
                                    style: TextStyle(
                                      color:
                                          Theme.of(
                                            context,
                                          ).colorScheme.tertiary,
                                      fontWeight: FontWeight.bold,
                                      fontSize: height * 0.018,
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
              ),
            ],
          ),
        ),
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
