// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:Konexea/Views/Components/Auth%20Components/my_form_field.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:Konexea/Controllers/input_controllers.dart';
import 'package:Konexea/Controllers/Services/User Profile/user_profile_service.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  // final AuthenticationController _authController = AuthenticationController();
  final InputControllers _inputControllers = InputControllers();
  final ImagePicker _picker = ImagePicker();
  String? _imageUrl;
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    // Load the user's profile image when the page loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userProfileService =
          Provider.of<UserProfileService>(context, listen: false);
      userProfileService.initializeUserProfile().then((_) {
        if (userProfileService.profileImageUrl != null) {
          setState(() {
            _imageUrl = userProfileService.profileImageUrl;
          });
        }
      });
    });
  }

  @override
  void dispose() {
    _inputControllers.dispose();
    super.dispose();
  }

  Future<void> _pickAndUploadImage() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) return;

    setState(() {
      _isUploading = true;
    });

    try {
      // Use the UserProfileService to upload the image and store in Firebase
      final userProfileService =
          Provider.of<UserProfileService>(context, listen: false);
      final success =
          await userProfileService.uploadProfileImage(pickedFile, context);

      if (success) {
        setState(() {
          _imageUrl = userProfileService.profileImageUrl;
          _isUploading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile image uploaded successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        throw Exception('Failed to upload image');
      }
    } catch (e) {
      print('Upload error: $e');
      setState(() {
        _isUploading = false;
      });

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Upload failed: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _inputControllers.loading = true);

      try {
        // Get the current user
        final supabase = Supabase.instance.client;
        final user = supabase.auth.currentUser;

        if (user != null) {
          // Create a map of profile data to update
          final profileData = {
            'name': _inputControllers.nameController.text,
            'email': _inputControllers.emailController.text,
            // Add the profile image URL if it exists
            if (_imageUrl != null) 'profile_image_url': _imageUrl,
            'updated_at': DateTime.now().toIso8601String(),
          };

          // Update the user profile in your database
          // This is an example - adjust according to your actual database structure
          await supabase.from('profiles').update(profileData).eq('id', user.id);

          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Profile updated successfully!')),
            );
          }
        } else {
          throw Exception('User not authenticated');
        }
      } catch (e) {
        print('Profile update error: $e');
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text('Failed to update profile: ${e.toString()}')),
          );
        }
      } finally {
        setState(() => _inputControllers.loading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    // final width = MediaQuery.of(context).size.width;
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
      body: SingleChildScrollView(
        child: Padding(
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

                // Profile Image Section
                Center(
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Theme.of(context).colorScheme.primary,
                                width: 2,
                              ),
                            ),
                            child: _isUploading
                                ? const Center(
                                    child: CircularProgressIndicator(),
                                  )
                                : ClipOval(
                                    child: _imageUrl != null
                                        ? Image.network(
                                            _imageUrl!,
                                            width: 120,
                                            height: 120,
                                            fit: BoxFit.cover,
                                          )
                                        : const Icon(
                                            Icons.person,
                                            size: 60,
                                            color: Colors.grey,
                                          ),
                                  ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: GestureDetector(
                              onTap: _pickAndUploadImage,
                              child: Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.primary,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.camera_alt,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Tap to change profile picture',
                        style: GoogleFonts.urbanist(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),

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
                    onPressed: _inputControllers.loading ? null : _saveProfile,
                    child: _inputControllers.loading
                        ? const CircularProgressIndicator(
                            color: Color(0xFF228B22))
                        : Text('Save Profile',
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: GoogleFonts.urbanist().fontFamily,
                                fontWeight: FontWeight.w600)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
