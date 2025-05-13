// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:social_swap/Views/Interface/Authentication/forgot_password.dart';
import 'package:social_swap/controllers/Services/Authentication/authentication_controller.dart';
import 'package:social_swap/controllers/input_controllers.dart';
import 'package:social_swap/views/Interface/Authentication/signup.dart';
import 'package:social_swap/views/components/auth_button.dart';
import 'package:social_swap/views/components/my_form_field.dart';

class LoginPage extends StatefulWidget {
  static const String id = 'LoginPage';
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final AuthenticationController _authController = AuthenticationController();
  final InputControllers _inputControllers = InputControllers();

  // Animation controller for slide-up effect
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  // Logo animations
  late Animation<double> _logoScaleAnimation;
  late Animation<double> _logoRotateAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    // Create slide-up animation
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutQuint,
    ));

    // Create fade-in animation
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    // Create logo scale animation
    _logoScaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));

    // Create logo rotation animation with reduced tilt
    _logoRotateAnimation = Tween<double>(
      begin: 0.0,
      end: 0.02, // Reduced tilt from 0.1 to 0.02
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));

    // Start animation after widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _animationController.forward();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
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
            SnackBar(
              content:
                  const Text("An unexpected error occurred. Please try again."),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.grey.shade100,
              Colors.grey.shade200,
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  // Logo - Moved outside the card
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: ScaleTransition(
                      scale: _logoScaleAnimation,
                      child: RotationTransition(
                        turns: _logoRotateAnimation,
                        child: Hero(
                          tag: 'logo',
                          child: Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.surface,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primary
                                      .withOpacity(0.3),
                                  blurRadius: 20,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Icon(
                                Icons.group,
                                size: 70,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: height * 0.03),

                  // Card with login form
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                        child: Card(
                          elevation: 15,
                          shadowColor: Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(0.3),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(28),
                          ),
                          color: Theme.of(context).colorScheme.surface,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: width * 0.05,
                              vertical: height * 0.04,
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Login Header
                                Text(
                                  "Log In",
                                  style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.tertiary,
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

                                // Subtitle
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

                                // Form
                                Form(
                                  key: _formKey,
                                  child: Column(
                                    children: [
                                      // Email Field
                                      MyFormField(
                                        hintText: "Email",
                                        hintStyle: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .tertiary
                                              .withOpacity(0.7),
                                        ),
                                        prefixIcon: Icons.alternate_email,
                                        controller:
                                            _inputControllers.emailController,
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please enter your email';
                                          }
                                          if (!value.contains('@')) {
                                            return 'Please enter a valid email';
                                          }
                                          return null;
                                        },
                                      ),
                                      SizedBox(height: height * 0.02),

                                      // Password Field
                                      MyFormField(
                                        hintText: "Password",
                                        hintStyle: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .tertiary
                                              .withOpacity(0.7),
                                        ),
                                        prefixIcon: Icons.lock_outline_rounded,
                                        controller: _inputControllers
                                            .passwordController,
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
                                      ),
                                    ],
                                  ),
                                ),

                                // Forgot Password Link
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: TextButton(
                                    onPressed: () {
                                      Navigator.of(context).push(
                                        _elegantRoute(
                                          const ForgotPassword(),
                                        ),
                                      );
                                    },
                                    style: TextButton.styleFrom(
                                      padding: EdgeInsets.zero,
                                      minimumSize: const Size(0, 36),
                                      tapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                    ),
                                    child: Text(
                                      "Forgot Password?",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        fontFamily:
                                            GoogleFonts.outfit().fontFamily,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: height * 0.02),

                                // Login Button
                                AuthButton(
                                  onPressed: _handleLogin,
                                  text: "Log In",
                                  textStyle: TextStyle(
                                    fontFamily: GoogleFonts.outfit().fontFamily,
                                    color:
                                        Theme.of(context).colorScheme.surface,
                                    fontSize: 19,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  isLoading: _inputControllers.loading,
                                ),
                                SizedBox(height: height * 0.025),

                                // Sign Up Link
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Don\'t have an account?',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .tertiary,
                                        fontFamily:
                                            GoogleFonts.outfit().fontFamily,
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: _navigateToSignUpScreen,
                                      child: Text(
                                        'Sign Up',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                          fontWeight: FontWeight.bold,
                                          fontFamily:
                                              GoogleFonts.outfit().fontFamily,
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
        ),
      ),
    );
  }

  void _navigateToSignUpScreen() {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const SignUpPage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOutCubic;

          var tween = Tween(
            begin: begin,
            end: end,
          ).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);

          return SlideTransition(position: offsetAnimation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 500),
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
