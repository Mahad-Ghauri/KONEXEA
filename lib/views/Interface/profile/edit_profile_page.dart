import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:social_swap/Controllers/Services/Authentication/authentication_controller.dart';
import 'package:social_swap/Controllers/input_controllers.dart';
import 'package:social_swap/views/components/my_form_field.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  // final AuthenticationController _authController = AuthenticationController();
  final InputControllers _inputControllers = InputControllers();

  @override
  void dispose() {
    _inputControllers.dispose();
    super.dispose();
  }

  void _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _inputControllers.loading = true);
      await Future.delayed(const Duration(seconds: 1)); // Simulate save
      setState(() => _inputControllers.loading = false);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully!')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile',
            style: TextStyle(
                fontFamily: GoogleFonts.urbanist().fontFamily,
                fontWeight: FontWeight.bold,
                fontSize: 20)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Update your profile',
                  style: GoogleFonts.urbanist(
                      fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 24),
              MyFormField(
                hintText: "Enter your name",
                prefixIcon: Icons.person,
                controller: _inputControllers.nameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              SizedBox(height: height * 0.02),
              MyFormField(
                hintText: "Email",
                hintStyle: TextStyle(
                  color: Theme.of(
                    context,
                  ).colorScheme.tertiary,
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
              MyFormField(
                hintText: "Password",
                hintStyle: TextStyle(
                  color: Theme.of(
                    context,
                  ).colorScheme.tertiary,
                ),
                prefixIcon: Icons.lock,
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
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    padding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 32,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: _inputControllers.loading ? null : _saveProfile,
                  child: _inputControllers.loading
                      ? const CircularProgressIndicator(
                          color: Color(0xFF228B22))
                      : Text('Save',
                          style: TextStyle(
                              color: const Color(0xFFFFFDD0),
                              fontFamily: GoogleFonts.urbanist().fontFamily,
                              fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
