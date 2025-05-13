// ignore_for_file: prefer_final_fields

import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:Konexea/controllers/Services/Authentication/authentication_controller.dart';
import 'package:Konexea/utils/flutter_toast.dart';

class SavedPostServices extends ChangeNotifier {
  // Instance for firebase firestore
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  // Instance for authentication controller
  final AuthenticationController _authController = AuthenticationController();

  // Variables
  List<Map<String, dynamic>> _savedPosts = [];
  bool loading = false;

  // Getters
  List<Map<String, dynamic>> get savedPosts => _savedPosts;

  // Method to save a post
  Future<bool> toggleSavePost(Map<String, dynamic> post) async {
    try {
      final userEmail = _authController.getCurrentUserEmail();
      if (userEmail == null) {
        FlutterToast().toastMessage("Please login to save posts");
        return false;
      }

      final String postId = post['postId'];

      // Check if post is already saved
      final DocumentSnapshot savedDoc = await _fireStore
          .collection("savedposts")
          .doc(userEmail)
          .collection("posts")
          .doc(postId)
          .get();

      if (savedDoc.exists) {
        // Post is already saved, so unsave it
        await _fireStore
            .collection("savedposts")
            .doc(userEmail)
            .collection("posts")
            .doc(postId)
            .delete();

        // Update local state
        _savedPosts.removeWhere((savedPost) => savedPost['postId'] == postId);
        notifyListeners();

        FlutterToast().toastMessage("Post removed from saved");
        return false;
      } else {
        // Post is not saved, so save it
        await _fireStore
            .collection("savedposts")
            .doc(userEmail)
            .collection("posts")
            .doc(postId)
            .set({
          'postId': postId,
          'image': post['image'] ?? '',
          'description': post['description'] ?? '',
          'timeStamp': post['timeStamp'] ?? DateTime.now(),
          'userEmail': post['userEmail'] ?? '',
          'savedAt': DateTime.now(),
        });

        // Update local state if we've already fetched saved posts
        if (_savedPosts.isNotEmpty) {
          _savedPosts.add({
            'postId': postId,
            'image': post['image'] ?? '',
            'description': post['description'] ?? '',
            'timeStamp': post['timeStamp'] ?? DateTime.now(),
            'userEmail': post['userEmail'] ?? '',
            'savedAt': DateTime.now(),
          });
          notifyListeners();
        }

        FlutterToast().toastMessage("Post saved successfully");
        return true;
      }
    } catch (error) {
      log('Error toggling save post: ${error.toString()}');
      FlutterToast().toastMessage("Error saving post");
      return false;
    }
  }

  // Method to check if a post is saved
  Future<bool> isPostSaved(String postId) async {
    try {
      final userEmail = _authController.getCurrentUserEmail();
      if (userEmail == null) {
        return false;
      }

      final DocumentSnapshot savedDoc = await _fireStore
          .collection("savedposts")
          .doc(userEmail)
          .collection("posts")
          .doc(postId)
          .get();

      return savedDoc.exists;
    } catch (error) {
      log('Error checking if post is saved: ${error.toString()}');
      return false;
    }
  }

  // Method to fetch saved posts
  Future<void> fetchSavedPosts() async {
    try {
      loading = true;
      notifyListeners();

      final userEmail = _authController.getCurrentUserEmail();
      if (userEmail == null) {
        loading = false;
        notifyListeners();
        return;
      }

      final QuerySnapshot querySnapshot = await _fireStore
          .collection("savedposts")
          .doc(userEmail)
          .collection("posts")
          .orderBy('savedAt', descending: true)
          .get();

      _savedPosts = querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return {
          'postId': doc.id,
          'image': data['image'] ?? '',
          'description': data['description'] ?? '',
          'timeStamp': data['timeStamp'] is Timestamp
              ? (data['timeStamp'] as Timestamp).toDate()
              : DateTime.now(),
          'userEmail': data['userEmail'] ?? '',
          'savedAt': data['savedAt'] is Timestamp
              ? (data['savedAt'] as Timestamp).toDate()
              : DateTime.now(),
        };
      }).toList();

      loading = false;
      notifyListeners();
    } catch (error) {
      loading = false;
      log('Error fetching saved posts: ${error.toString()}');
      notifyListeners();
    }
  }

  // Method to remove all saved posts
  Future<void> clearAllSavedPosts() async {
    try {
      final userEmail = _authController.getCurrentUserEmail();
      if (userEmail == null) {
        FlutterToast().toastMessage("Please login to clear saved posts");
        return;
      }

      loading = true;
      notifyListeners();

      // Get all saved posts
      final QuerySnapshot querySnapshot = await _fireStore
          .collection("savedposts")
          .doc(userEmail)
          .collection("posts")
          .get();

      // Delete each document
      for (var doc in querySnapshot.docs) {
        await doc.reference.delete();
      }

      // Clear local state
      _savedPosts = [];
      loading = false;
      notifyListeners();

      FlutterToast().toastMessage("All saved posts cleared");
    } catch (error) {
      loading = false;
      log('Error clearing saved posts: ${error.toString()}');
      FlutterToast().toastMessage("Error clearing saved posts");
      notifyListeners();
    }
  }
}
