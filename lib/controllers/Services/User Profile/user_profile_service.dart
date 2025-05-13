import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:image_picker/image_picker.dart';

class UserProfileService extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final supabase = Supabase.instance.client;
  
  String? _profileImageUrl;
  bool _isLoading = false;
  
  String? get profileImageUrl => _profileImageUrl;
  bool get isLoading => _isLoading;
  
  // Collection name for user profiles
  static const String _userProfilesCollection = 'user_profiles';
  
  // Initialize and load user profile data
  Future<void> initializeUserProfile() async {
    final user = supabase.auth.currentUser;
    if (user != null) {
      await loadUserProfileImage(user.email!);
    }
  }
  
  // Upload profile image to Supabase and store URL in Firebase
  Future<bool> uploadProfileImage(XFile pickedFile, BuildContext context) async {
    final user = supabase.auth.currentUser;
    if (user == null) {
      log('No authenticated user found');
      return false;
    }
    
    try {
      _isLoading = true;
      notifyListeners();
      
      final file = File(pickedFile.path);
      final fileName = '${DateTime.now().millisecondsSinceEpoch}_${pickedFile.name}';
      
      // Upload to Supabase storage
      await supabase.storage.from('profileimage').upload(fileName, file);
      
      // Get the public URL
      final imageUrl = supabase.storage.from('profileimage').getPublicUrl(fileName);
      
      // Store in Firebase
      await _firestore.collection(_userProfilesCollection).doc(user.email).set({
        'email': user.email,
        'profileImageUrl': imageUrl,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
      
      _profileImageUrl = imageUrl;
      _isLoading = false;
      notifyListeners();
      
      return true;
    } catch (e) {
      log('Profile image upload error: $e');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
  
  // Load user profile image from Firebase
  Future<void> loadUserProfileImage(String email) async {
    try {
      _isLoading = true;
      notifyListeners();
      
      final docSnapshot = await _firestore.collection(_userProfilesCollection).doc(email).get();
      
      if (docSnapshot.exists && docSnapshot.data()!.containsKey('profileImageUrl')) {
        _profileImageUrl = docSnapshot.data()!['profileImageUrl'];
      } else {
        _profileImageUrl = null; // No profile image set
      }
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      log('Error loading profile image: $e');
      _isLoading = false;
      notifyListeners();
    }
  }
  
  // Get profile image for a specific user
  Future<String?> getUserProfileImage(String email) async {
    try {
      final docSnapshot = await _firestore.collection(_userProfilesCollection).doc(email).get();
      
      if (docSnapshot.exists && docSnapshot.data()!.containsKey('profileImageUrl')) {
        return docSnapshot.data()!['profileImageUrl'];
      }
      return null;
    } catch (e) {
      log('Error getting user profile image: $e');
      return null;
    }
  }
}