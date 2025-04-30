// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:social_swap/controllers/Services/Authentication/authentication_controller.dart';
import 'package:social_swap/controllers/input_controllers.dart';
import 'package:social_swap/views/Interface/Authentication/login.dart';
import 'package:social_swap/views/components/auth_button.dart';
import 'package:social_swap/views/components/my_form_field.dart';

class SignUpPage extends StatefulWidget {
  static const String id = 'SignUpPage';
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final AuthenticationController _authController = AuthenticationController();
  final InputControllers _inputControllers = InputControllers();
  
  // Animation controller for slide-up effect
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

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
      begin: const Offset(0, 0.5),
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

  Future<void> _handleSignUp() async {
    if (_formKey.currentState!.validate()) {
      if (_inputControllers.passwordController.text !=
          _inputControllers.confirmPasswordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Passwords do not match'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          )
        );
        return;
      }
      
      setState(() {
        _inputControllers.loading = true;
      });
      
      try {
        await _authController.signUpWithEmailPassword(
          _inputControllers.emailController.text,
          _inputControllers.passwordController.text,
          context,
        ).then((_) {
          Navigator.of(context).pushReplacement(_createPageRoute(const LoginPage(), slideDirection: 'right'));
        });
      } catch (error) {
        if (mounted) {
          setState(() {
            _inputControllers.loading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text("An unexpected error occurred. Please try again."),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
              Colors.black.withOpacity(0.3),
              Colors.black.withOpacity(0.1),
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                    child: Card(
                      elevation: 15,
                      shadowColor: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                      color: Theme.of(context).colorScheme.surface,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: width * 0.05,
                          vertical: height * 0.03,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // SignUp Header
                            Text(
                              "Sign Up",
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.tertiary,
                                fontWeight: FontWeight.bold,
                                fontSize: height * 0.045,
                                letterSpacing: 2,
                                fontFamily: GoogleFonts.italiana().fontFamily,
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
                              "Welcome to Social Swap",
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.tertiary.withOpacity(0.9),
                                fontSize: height * 0.018,
                                fontFamily: GoogleFonts.urbanist().fontFamily,
                                letterSpacing: 0.5,
                              ),
                            ),
                            SizedBox(height: height * 0.025),
                            
                            // Form
                            Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  // Name Field
                                  MyFormField(
                                    hintText: "Enter your name",
                                    hintStyle: TextStyle(
                                      color: Theme.of(context).colorScheme.tertiary.withOpacity(0.7),
                                    ),
                                    prefixIcon: Icons.person_outline_rounded,
                                    controller: _inputControllers.nameController,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter your name';
                                      }
                                      return null;
                                    },
                                  ),
                                  SizedBox(height: height * 0.02),
                                  
                                  // Email Field
                                  MyFormField(
                                    hintText: "Email",
                                    hintStyle: TextStyle(
                                      color: Theme.of(context).colorScheme.tertiary.withOpacity(0.7),
                                    ),
                                    prefixIcon: Icons.alternate_email,
                                    controller: _inputControllers.emailController,
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
                                  ),
                                  SizedBox(height: height * 0.02),
                                  
                                  // Password Field
                                  MyFormField(
                                    hintText: "Password",
                                    hintStyle: TextStyle(
                                      color: Theme.of(context).colorScheme.tertiary.withOpacity(0.7),
                                    ),
                                    prefixIcon: Icons.lock_outline_rounded,
                                    controller: _inputControllers.passwordController,
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
                                  SizedBox(height: height * 0.02),
                                  
                                  // Confirm Password Field
                                  MyFormField(
                                    hintText: "Confirm Password",
                                    hintStyle: TextStyle(
                                      color: Theme.of(context).colorScheme.tertiary.withOpacity(0.7),
                                    ),
                                    prefixIcon: Icons.lock_outline_rounded,
                                    controller: _inputControllers.confirmPasswordController,
                                    obscureText: true,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please confirm your password';
                                      }
                                      if (value != _inputControllers.passwordController.text) {
                                        return 'Passwords do not match';
                                      }
                                      return null;
                                    },
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: height * 0.03),
                            
                            // SignUp Button
                            AuthButton(
                              onPressed: _handleSignUp,
                              text: "Sign Up",
                              textStyle: TextStyle(
                                fontFamily: GoogleFonts.outfit().fontFamily,
                                color: Theme.of(context).colorScheme.surface,
                                fontSize: 19,
                                fontWeight: FontWeight.bold,
                              ),
                              isLoading: _inputControllers.loading,
                            ),
                            SizedBox(height: height * 0.02),
                            
                            // Login Link
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Already have an account?',
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.tertiary,
                                    fontFamily: GoogleFonts.outfit().fontFamily,
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).push(_createPageRoute(
                                      const LoginPage(),
                                      slideDirection: 'right'
                                    ));
                                  },
                                  child: Text(
                                    'Login',
                                    style: TextStyle(
                                      color: Theme.of(context).colorScheme.primary,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: GoogleFonts.outfit().fontFamily,
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
            ),
          ),
        ),
      ),
    );
  }

  PageRouteBuilder _createPageRoute(Widget page, {String slideDirection = 'left'}) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        // Define slide offset based on direction
        Offset beginOffset;
        if (slideDirection == 'left') {
          beginOffset = const Offset(1.0, 0.0); // Slide from right
        } else if (slideDirection == 'right') {
          beginOffset = const Offset(-1.0, 0.0); // Slide from left
        } else if (slideDirection == 'up') {
          beginOffset = const Offset(0.0, 1.0); // Slide from bottom
        } else {
          beginOffset = const Offset(0.0, -1.0); // Slide from top
        }
        
        // Create slide transition
        var slideAnimation = Tween<Offset>(
          begin: beginOffset,
          end: Offset.zero,
        ).animate(CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
        ));
        
        // Create fade transition
        var fadeAnimation = Tween<double>(begin: 0.3, end: 1.0).animate(
          CurvedAnimation(parent: animation, curve: Curves.easeInOut),
        );
        
        // Apply transitions
        return FadeTransition(
          opacity: fadeAnimation,
          child: SlideTransition(
            position: slideAnimation,
            child: child,
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 600),
    );
  }
}