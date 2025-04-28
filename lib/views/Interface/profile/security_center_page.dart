// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:social_swap/Views/components/my_form_field.dart';

class SecurityCenterPage extends StatefulWidget {
  const SecurityCenterPage({super.key});

  @override
  State<SecurityCenterPage> createState() => _SecurityCenterPageState();
}

class _SecurityCenterPageState extends State<SecurityCenterPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _isLoading = false;
  bool _is2FAEnabled = false;

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _saveSecurity() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      await Future.delayed(const Duration(seconds: 1)); // Simulate save
      setState(() => _isLoading = false);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Security settings updated!')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text('Security Center',
            style: TextStyle(
              fontFamily: GoogleFonts.urbanist().fontFamily,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            )),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Text('Change Password',
                  style: GoogleFonts.urbanist(
                      fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(height: height * 0.02),
              MyFormField(
                hintText: "Old Password",
                hintStyle: TextStyle(
                  color: Theme.of(
                    context,
                  ).colorScheme.tertiary,
                ),
                prefixIcon: Icons.lock,
                controller: _oldPasswordController,
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
              MyFormField(
                hintText: "Enter new password",
                hintStyle: TextStyle(
                  color: Theme.of(
                    context,
                  ).colorScheme.tertiary,
                ),
                prefixIcon: Icons.lock,
                controller: _newPasswordController,
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
              MyFormField(
                hintText: "Confirm new password",
                hintStyle: TextStyle(
                  color: Theme.of(
                    context,
                  ).colorScheme.tertiary,
                ),
                prefixIcon: Icons.lock,
                controller: _confirmPasswordController,
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
              SwitchListTile(
                title: Text(
                  'Enable Two-Factor Authentication',
                  style: TextStyle(
                    fontFamily: GoogleFonts.urbanist().fontFamily,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                subtitle: Text(
                  'Protect your account with an extra layer of security',
                  style: TextStyle(
                    fontFamily: GoogleFonts.urbanist().fontFamily,
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                secondary: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: _is2FAEnabled
                        ? Colors.green.withOpacity(0.2)
                        : Colors.grey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    _is2FAEnabled ? Icons.security : Icons.security_outlined,
                    color: _is2FAEnabled ? Colors.green : Colors.grey,
                  ),
                ),
                value: _is2FAEnabled,
                onChanged: (value) {
                  setState(() {
                    _is2FAEnabled = value;
                    if (value) {
                      // Show setup dialog or navigate to 2FA setup page
                      // showSetup2FADialog();
                    }
                  });
                },
                activeColor: Theme.of(context).primaryColor,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  // side: BorderSide(
                  //   color: _is2FAEnabled
                  //       ? Theme.of(context).primaryColor.withOpacity(0.3)
                  //       : Colors.transparent,
                  //   width: 1,
                  // ),
                ),
              ),
              SizedBox(height: height * 0.04),
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
                  onPressed: _isLoading ? null : _saveSecurity,
                  child: _isLoading
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
