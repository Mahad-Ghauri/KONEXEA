// ignore_for_file: prefer_final_fields

import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:Konexea/controllers/Services/Authentication/authentication_controller.dart';
import 'package:Konexea/utils/flutter_toast.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Comment {
  final String id;
  final String postId;
  final String userEmail;
  final String text;
  final DateTime timestamp;
  final String? parentId; // For threaded comments (null for top-level comments)
  final List<String> likes;

  Comment({
    required this.id,
    required this.postId,
    required this.userEmail,
    required this.text,
    required this.timestamp,
    this.parentId,
    required this.likes,
  });

  factory Comment.fromMap(Map<String, dynamic> map, String id) {
    return Comment(
      id: id,
      postId: map['postId'] ?? '',
      userEmail: map['userEmail'] ?? '',
      text: map['text'] ?? '',
      timestamp: (map['timestamp'] as Timestamp).toDate(),
      parentId: map['parentId'],
      likes: List<String>.from(map['likes'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'postId': postId,
      'userEmail': userEmail,
      'text': text,
      'timestamp': Timestamp.fromDate(timestamp),
      'parentId': parentId,
      'likes': likes,
    };
  }
}

class FeedServices extends ChangeNotifier {
  //  Instance for firebase firestore
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  //  Instance for supabase database
  final SupabaseClient _supabase = Supabase.instance.client;

  //  Instance for authentication controller
  final AuthenticationController _authController = AuthenticationController();

  //  variables
  File? _image;
  final picker = ImagePicker();
  List<Map<String, dynamic>> _posts = [];
  Map<String, List<Comment>> _comments = {};
  Map<String, List<String>> _postLikes = {};

  //  getters
  FirebaseFirestore get fireStore => _fireStore;
  SupabaseClient get supabase => _supabase;
  File? get image => _image;
  bool loading = false;
  bool commentsLoading = false;
  List<Map<String, dynamic>> get posts => _posts;
  Map<String, List<Comment>> get comments => _comments;
  Map<String, List<String>> get postLikes => _postLikes;

  //  Method to fetch posts from firestore
  Future<void> fetchPosts() async {
    try {
      loading = true;
      notifyListeners();

      final QuerySnapshot querySnapshot = await _fireStore
          .collection("Feed")
          .orderBy('timeStamp', descending: true)
          .get();

      _posts = querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return {
          'postId': doc.id,
          'image': data['image'] ?? '',
          'description': data['description'] ?? '',
          'timeStamp': (data['timeStamp'] as Timestamp).toDate(),
          'userEmail': data['userEmail'] ?? '',
        };
      }).toList();

      // Fetch likes for each post
      for (var post in _posts) {
        await fetchPostLikes(post['postId']);
      }

      loading = false;
      notifyListeners();
    } catch (error) {
      loading = false;
      log(error.toString());
      notifyListeners();
    }
  }

  // Method to fetch likes for a specific post
  Future<void> fetchPostLikes(String postId) async {
    try {
      final DocumentSnapshot likeDoc =
          await _fireStore.collection("Likes").doc(postId).get();

      if (likeDoc.exists) {
        final data = likeDoc.data() as Map<String, dynamic>;
        _postLikes[postId] = List<String>.from(data['users'] ?? []);
      } else {
        _postLikes[postId] = [];
      }

      notifyListeners();
    } catch (error) {
      log('Error fetching likes: ${error.toString()}');
    }
  }

  //  Method to pick the image from the gallery
  Future<void> pickImageFromGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      _image = File(pickedFile.path);
    }
    notifyListeners();
  }

  //  Method to upload the data to the database
  Future<void> uploadDataToDatabase(
    TextEditingController descriptionController,
    BuildContext context,
  ) async {
    //  Check if the image is selected or not
    if (_image == null) {
      FlutterToast().toastMessage("Please Select an Image");
      notifyListeners();
      return;
    }

    //  Check if the description controller is empty
    if (descriptionController.text.isEmpty) {
      FlutterToast().toastMessage("Please Write a description");
      notifyListeners();
      return;
    }

    // Get current user's email
    final userEmail = _authController.getCurrentUserEmail();
    if (userEmail == null) {
      FlutterToast().toastMessage("Please login to post");
      notifyListeners();
      return;
    }

    String postId = DateTime.now().microsecondsSinceEpoch.toString();
    String fileName = "post_$postId.jpg";

    //  Read the image as bytes and store into the bucket
    try {
      loading = true;
      notifyListeners();

      final bytes = await _image!.readAsBytes();

      //  image went to storage
      await supabase.storage.from("feedposts").updateBinary(fileName, bytes);

      final imageUrl =
          supabase.storage.from("feedposts").getPublicUrl(fileName);

      //  Post the data to firestore database
      await fireStore.collection("Feed").doc(postId).set({
        'image': imageUrl,
        'description': descriptionController.text,
        'postId': postId,
        'timeStamp': DateTime.timestamp(),
        'userEmail': userEmail,
      }).then((value) {
        log("Post Uploaded");
        descriptionController.clear();
        _image = null;
        loading = false;
        notifyListeners();
      }).onError((error, stacktrace) {
        loading = false;
        FlutterToast().toastMessage(error.toString());
        log(error.toString());
        notifyListeners();
      });
    } catch (error) {
      log(error.toString());
    }
  }

  Future<void> loadMorePosts() async {
    try {
      loading = true;
      notifyListeners();

      // Get the last document from the current list
      final lastPost = _posts.isNotEmpty ? _posts.last : null;

      if (lastPost != null) {
        final lastTimestamp = lastPost['timeStamp'] as DateTime;

        // Query for more posts after the last timestamp
        final QuerySnapshot querySnapshot = await _fireStore
            .collection("Feed")
            .orderBy('timeStamp', descending: true)
            .startAfter([lastTimestamp])
            .limit(10) // Load 10 more posts at a time
            .get();

        final newPosts = querySnapshot.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          return {
            'postId': doc.id,
            'image': data['image'] ?? '',
            'description': data['description'] ?? '',
            'timeStamp': (data['timeStamp'] as Timestamp).toDate(),
            'userEmail': data['userEmail'] ?? '',
          };
        }).toList();

        // Add new posts to the existing list
        _posts.addAll(newPosts);

        // Fetch likes for new posts
        for (var post in newPosts) {
          await fetchPostLikes(post['postId']);
        }
      }

      loading = false;
      notifyListeners();
    } catch (e) {
      loading = false;
      debugPrint('Error loading more posts: $e');
      notifyListeners();
    }
  }

  // Method to like or unlike a post
  Future<bool> toggleLikePost(String postId) async {
    try {
      final userEmail = _authController.getCurrentUserEmail();
      if (userEmail == null) {
        FlutterToast().toastMessage("Please login to like posts");
        return false;
      }

      // Initialize likes list if it doesn't exist
      if (!_postLikes.containsKey(postId)) {
        _postLikes[postId] = [];
      }

      // Check if user already liked the post
      bool isLiked = _postLikes[postId]!.contains(userEmail);

      // Update local state
      if (isLiked) {
        _postLikes[postId]!.remove(userEmail);
      } else {
        _postLikes[postId]!.add(userEmail);
      }
      notifyListeners();

      // Update in Firestore
      await _fireStore.collection("Likes").doc(postId).set({
        'users': _postLikes[postId],
      });

      return !isLiked; // Return new like state
    } catch (error) {
      log('Error toggling like: ${error.toString()}');
      return false;
    }
  }

  // Method to check if current user liked a post
  bool isPostLikedByCurrentUser(String postId) {
    final userEmail = _authController.getCurrentUserEmail();
    if (userEmail == null || !_postLikes.containsKey(postId)) {
      return false;
    }
    return _postLikes[postId]!.contains(userEmail);
  }

  // Method to get like count for a post
  int getLikeCount(String postId) {
    if (!_postLikes.containsKey(postId)) {
      return 0;
    }
    return _postLikes[postId]!.length;
  }

  // Method to fetch comments for a post
  Future<List<Comment>> fetchComments(String postId) async {
    try {
      commentsLoading = true;
      notifyListeners();

      final QuerySnapshot querySnapshot = await _fireStore
          .collection("Comments")
          .where('postId', isEqualTo: postId)
          .orderBy('timestamp', descending: true)
          .get();

      final comments = querySnapshot.docs.map((doc) {
        return Comment.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();

      _comments[postId] = comments;

      commentsLoading = false;
      notifyListeners();

      return comments;
    } catch (error) {
      commentsLoading = false;
      log('Error fetching comments: ${error.toString()}');
      notifyListeners();
      return [];
    }
  }

  // Method to add a comment to a post
  Future<Comment?> addComment(String postId, String text,
      {String? parentId}) async {
    try {
      final userEmail = _authController.getCurrentUserEmail();
      if (userEmail == null) {
        FlutterToast().toastMessage("Please login to comment");
        return null;
      }

      if (text.trim().isEmpty) {
        FlutterToast().toastMessage("Comment cannot be empty");
        return null;
      }

      // Create a new comment document reference
      final commentRef = _fireStore.collection("Comments").doc();

      final comment = Comment(
        id: commentRef.id,
        postId: postId,
        userEmail: userEmail,
        text: text,
        timestamp: DateTime.now(),
        parentId: parentId,
        likes: [],
      );

      // Save to Firestore
      await commentRef.set(comment.toMap());

      // Update local state
      if (!_comments.containsKey(postId)) {
        _comments[postId] = [];
      }
      _comments[postId]!.insert(0, comment); // Add to beginning of list

      notifyListeners();
      return comment;
    } catch (error) {
      log('Error adding comment: ${error.toString()}');
      return null;
    }
  }

  // Method to like or unlike a comment
  Future<bool> toggleLikeComment(Comment comment) async {
    try {
      final userEmail = _authController.getCurrentUserEmail();
      if (userEmail == null) {
        FlutterToast().toastMessage("Please login to like comments");
        return false;
      }

      // Check if user already liked the comment
      bool isLiked = comment.likes.contains(userEmail);
      List<String> updatedLikes = List.from(comment.likes);

      // Update likes list
      if (isLiked) {
        updatedLikes.remove(userEmail);
      } else {
        updatedLikes.add(userEmail);
      }

      // Update in Firestore
      await _fireStore.collection("Comments").doc(comment.id).update({
        'likes': updatedLikes,
      });

      // Update local state
      if (_comments.containsKey(comment.postId)) {
        final index =
            _comments[comment.postId]!.indexWhere((c) => c.id == comment.id);
        if (index != -1) {
          final updatedComment = Comment(
            id: comment.id,
            postId: comment.postId,
            userEmail: comment.userEmail,
            text: comment.text,
            timestamp: comment.timestamp,
            parentId: comment.parentId,
            likes: updatedLikes,
          );
          _comments[comment.postId]![index] = updatedComment;
        }
      }

      notifyListeners();
      return !isLiked; // Return new like state
    } catch (error) {
      log('Error toggling comment like: ${error.toString()}');
      return false;
    }
  }

  // Method to check if current user liked a comment
  bool isCommentLikedByCurrentUser(Comment comment) {
    final userEmail = _authController.getCurrentUserEmail();
    if (userEmail == null) {
      return false;
    }
    return comment.likes.contains(userEmail);
  }
}
