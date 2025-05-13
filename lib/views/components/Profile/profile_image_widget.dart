import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:Konexea/Controllers/Services/User Profile/user_profile_service.dart';

class ProfileImageWidget extends StatelessWidget {
  final double size;
  final bool isEditable;
  final String? email;
  
  const ProfileImageWidget({
    super.key,
    this.size = 60.0,
    this.isEditable = false,
    this.email,
  });

  @override
  Widget build(BuildContext context) {
    final userProfileService = Provider.of<UserProfileService>(context);
    final currentUserEmail = email ?? userProfileService.supabase.auth.currentUser?.email;
    
    return FutureBuilder<String?>(
      future: currentUserEmail != null 
          ? userProfileService.getUserProfileImage(currentUserEmail)
          : Future.value(null),
      builder: (context, snapshot) {
        final imageUrl = snapshot.data ?? userProfileService.profileImageUrl;
        
        return Stack(
          children: [
            CircleAvatar(
              radius: size / 2,
              backgroundColor: Colors.grey[300],
              backgroundImage: imageUrl != null ? NetworkImage(imageUrl) : null,
              child: imageUrl == null
                  ? Icon(
                      Icons.person,
                      size: size * 0.6,
                      color: Colors.grey[600],
                    )
                  : null,
            ),
            if (isEditable)
              Positioned(
                right: 0,
                bottom: 0,
                child: GestureDetector(
                  onTap: () => _showImagePickerOptions(context),
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.edit,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  void _showImagePickerOptions(BuildContext context) {
    final userProfileService = Provider.of<UserProfileService>(context, listen: false);
    
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from Gallery'),
              onTap: () async {
                Navigator.of(context).pop();
                final ImagePicker picker = ImagePicker();
                final XFile? image = await picker.pickImage(source: ImageSource.gallery);
                
                if (image != null && context.mounted) {
                  final success = await userProfileService.uploadProfileImage(image, context);
                  
                  if (success && context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Profile image updated successfully!'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  } else if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Failed to update profile image. Please try again.'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Take a Photo'),
              onTap: () async {
                Navigator.of(context).pop();
                final ImagePicker picker = ImagePicker();
                final XFile? photo = await picker.pickImage(source: ImageSource.camera);
                
                if (photo != null && context.mounted) {
                  final success = await userProfileService.uploadProfileImage(photo, context);
                  
                  if (success && context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Profile image updated successfully!'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  } else if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Failed to update profile image. Please try again.'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}