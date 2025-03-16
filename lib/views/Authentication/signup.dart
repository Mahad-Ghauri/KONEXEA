import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:social_swap/views/components/auth_button.dart';
import 'package:social_swap/views/components/my_form_field.dart';
import 'package:social_swap/utils/routes.dart';

class SignUpPage extends StatelessWidget {
  static const String id = 'SignUpPage';
  const SignUpPage({super.key});

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
                                    offset: Offset(2, 2),
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
                              child: Column(
                                children: [
                                  MyFormField(
                                    hintText: "Enter your name",
                                    prefixIcon: Icons.person,
                                  ),
                                  SizedBox(height: height * 0.02),
                                  MyFormField(
                                    hintText: "Email",
                                    prefixIcon: Icons.alternate_email,
                                  ),
                                  SizedBox(height: height * 0.02),
                                  MyFormField(
                                    hintText: "Password",
                                    prefixIcon: Icons.lock,
                                  ),
                                  SizedBox(height: height * 0.02),
                                  MyFormField(
                                    hintText: "Confirm Password",
                                    prefixIcon: Icons.lock,
                                    
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: height * 0.02),
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () {},
                                child: Text(
                                  "Forgot Password?",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: height * 0.017,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: height * 0.02),
                            AuthButton(
                              onPressed: () {
                                Navigator.pushReplacementNamed(
                                  context,
                                  Routes.home,
                                );
                              },
                              text: "Sign Up",
                            ),
                            SizedBox(height: height * 0.025),
                            Row(
                              children: [
                                Expanded(
                                  child: Divider(
                                    color: Colors.white.withOpacity(0.5),
                                    thickness: 1,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: width * 0.03,
                                  ),
                                  child: Text(
                                    "OR",
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.8),
                                      fontSize: height * 0.015,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Divider(
                                    color: Colors.white.withOpacity(0.5),
                                    thickness: 1,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: height * 0.025),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Already a member?",
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.9),
                                    fontSize: height * 0.017,
                                  ),
                                ),
                                TextButton(
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
                                  onPressed: () {
                                    Navigator.pushReplacementNamed(
                                      context,
                                      Routes.login,
                                    );
                                  },
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
}
