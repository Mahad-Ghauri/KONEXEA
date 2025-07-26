// ignore_for_file: unused_local_variable, depend_on_referenced_packages

import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:Konexea/controllers/Services/Authentication/authentication_controller.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:path/path.dart' as path;

class ChatServices extends ChangeNotifier {
  // Instance for Firebase Firestore
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  // Instance for Supabase
  final SupabaseClient _supabase = Supabase.instance.client;

  // Instance for authentication controller
  final AuthenticationController _authController = AuthenticationController();

  // Variables
  bool _loading = false;
  List<Map<String, dynamic>> _chats = [];
  List<Map<String, dynamic>> _messages = [];
  String? _currentChatId;
  final Map<String, String> _usernameCache = {};
  List<Map<String, dynamic>> _allUsers = [];

  // Getters
  bool get loading => _loading;
  List<Map<String, dynamic>> get chats => _chats;
  List<Map<String, dynamic>> get messages => _messages;
  String? get currentChatId => _currentChatId;
  List<Map<String, dynamic>> get allUsers => _allUsers;

  // Method to fetch all chats for the current user
  Future<void> fetchChats() async {
    try {
      _loading = true;
      notifyListeners();

      // Get current user's email
      final userEmail = _authController.getCurrentUserEmail();
      if (userEmail == null) {
        _loading = false;
        notifyListeners();
        return;
      }

      // Query chats where the current user is a participant
      final QuerySnapshot querySnapshot = await _fireStore
          .collection("Chats")
          .where('participants', arrayContains: userEmail)
          .orderBy('lastMessageTime', descending: true)
          .get();

      _chats = await Future.wait(querySnapshot.docs.map((doc) async {
        final data = doc.data() as Map<String, dynamic>;
        final participants = List<String>.from(data['participants'] ?? []);

        // Get the other participant's email (for 1:1 chats)
        final otherParticipantEmail = participants.firstWhere(
          (email) => email != userEmail,
          orElse: () => 'Unknown',
        );

        // Get username for the other participant
        final otherUsername = await getUsernameFromEmail(otherParticipantEmail);

        return {
          'chatId': doc.id,
          'participants': participants,
          'lastMessage': data['lastMessage'] ?? '',
          'lastMessageTime':
              (data['lastMessageTime'] as Timestamp?)?.toDate() ??
                  DateTime.now(),
          'unreadCount': data['unreadCount'] ?? 0,
          'otherParticipantEmail': otherParticipantEmail,
          'otherParticipantUsername': otherUsername,
        };
      }).toList());

      _loading = false;
      notifyListeners();
    } catch (error) {
      _loading = false;
      log('Error fetching chats: $error');
      notifyListeners();
    }
  }

  // Method to fetch messages for a specific chat
  Future<void> fetchMessages(String chatId) async {
    try {
      _loading = true;
      _currentChatId = chatId;
      notifyListeners();

      final QuerySnapshot querySnapshot = await _fireStore
          .collection("Chats")
          .doc(chatId)
          .collection("Messages")
          .orderBy('timestamp', descending: false)
          .get();

      _messages = querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return {
          'messageId': doc.id,
          'senderId': data['senderId'] ?? '',
          'senderEmail': data['senderEmail'] ?? '',
          'text': data['text'] ?? '',
          'imageUrl': data['imageUrl'] ?? '',
          'type': data['type'] ?? 'text',
          'timestamp':
              (data['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
          'isRead': data['isRead'] ?? false,
        };
      }).toList();

      // Mark messages as read
      await markMessagesAsRead(chatId);

      _loading = false;
      notifyListeners();
    } catch (error) {
      _loading = false;
      log('Error fetching messages: $error');
      notifyListeners();
    }
  }

  // Method to send a message
  Future<void> sendMessage(String recipientEmail, String messageText) async {
    try {
      // Get current user's email
      final userEmail = _authController.getCurrentUserEmail();
      if (userEmail == null) {
        return;
      }

      // Check if a chat already exists between these users
      String chatId = await _findOrCreateChat(userEmail, recipientEmail);

      // Add the message to the chat
      final messageData = {
        'senderId': _supabase.auth.currentUser!.id,
        'senderEmail': userEmail,
        'text': messageText,
        'timestamp': FieldValue.serverTimestamp(),
        'isRead': false,
      };

      await _fireStore
          .collection("Chats")
          .doc(chatId)
          .collection("Messages")
          .add(messageData);

      // Update the chat with the last message
      await _fireStore.collection("Chats").doc(chatId).update({
        'lastMessage': messageText,
        'lastMessageTime': FieldValue.serverTimestamp(),
        'lastSender': userEmail,
        // Increment unread count for the recipient
        'unreadCount': FieldValue.increment(1),
      });

      // If this is the current chat, refresh messages
      if (_currentChatId == chatId) {
        await fetchMessages(chatId);
      }

      // Refresh the chat list
      await fetchChats();
    } catch (error) {
      log('Error sending message: $error');
    }
  }

  // Method to mark messages as read
  Future<void> markMessagesAsRead(String chatId) async {
    try {
      final userEmail = _authController.getCurrentUserEmail();
      if (userEmail == null) {
        return;
      }

      // Get unread messages sent by others
      final QuerySnapshot unreadMessages = await _fireStore
          .collection("Chats")
          .doc(chatId)
          .collection("Messages")
          .where('isRead', isEqualTo: false)
          .where('senderEmail', isNotEqualTo: userEmail)
          .get();

      // Mark each message as read
      final batch = _fireStore.batch();
      for (var doc in unreadMessages.docs) {
        batch.update(doc.reference, {'isRead': true});
      }
      await batch.commit();

      // Reset unread count for this chat
      await _fireStore.collection("Chats").doc(chatId).update({
        'unreadCount': 0,
      });

      // Refresh chat list
      await fetchChats();
    } catch (error) {
      log('Error marking messages as read: $error');
    }
  }

  // Helper method to find an existing chat or create a new one
  Future<String> _findOrCreateChat(
      String userEmail, String recipientEmail) async {
    try {
      // Check if a chat already exists between these users
      final QuerySnapshot existingChats = await _fireStore
          .collection("Chats")
          .where('participants', arrayContains: userEmail)
          .get();

      // Look for a chat that contains both users
      for (var doc in existingChats.docs) {
        final participants = List<String>.from(
            (doc.data() as Map<String, dynamic>)['participants'] ?? []);
        if (participants.contains(recipientEmail)) {
          return doc.id;
        }
      }

      // If no chat exists, create a new one
      final chatData = {
        'participants': [userEmail, recipientEmail],
        'createdAt': FieldValue.serverTimestamp(),
        'lastMessage': '',
        'lastMessageTime': FieldValue.serverTimestamp(),
        'unreadCount': 0,
      };

      final docRef = await _fireStore.collection("Chats").add(chatData);
      return docRef.id;
    } catch (error) {
      log('Error finding or creating chat: $error');
      rethrow;
    }
  }

  // Method to get username from email
  Future<String> getUsernameFromEmail(String email) async {
    // Check cache first
    if (_usernameCache.containsKey(email)) {
      return _usernameCache[email]!;
    }

    try {
      // Extract username from email (before @)
      final String username = email.contains('@') ? email.split('@')[0] : email;

      // Cache the result
      _usernameCache[email] = username;

      return username;
    } catch (error) {
      log('Error getting username: $error');
      return email; // Fallback to email if username can't be extracted
    }
  }

  // Method to start a new chat with a user
  Future<void> startNewChat(String recipientEmail) async {
    try {
      final userEmail = _authController.getCurrentUserEmail();
      if (userEmail == null) {
        return;
      }

      // Create a new chat or get existing one
      final chatId = await _findOrCreateChat(userEmail, recipientEmail);

      // Set as current chat and fetch messages
      _currentChatId = chatId;
      await fetchMessages(chatId);
    } catch (error) {
      log('Error starting new chat: $error');
    }
  }

  // Method to listen for new messages in real-time
  Stream<List<Map<String, dynamic>>> getMessagesStream(String chatId) {
    return _fireStore
        .collection("Chats")
        .doc(chatId)
        .collection("Messages")
        .orderBy('timestamp', descending: false)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'messageId': doc.id,
          'senderId': data['senderId'] ?? '',
          'senderEmail': data['senderEmail'] ?? '',
          'text': data['text'] ?? '',
          'imageUrl': data['imageUrl'] ?? '',
          'type': data['type'] ?? 'text',
          'timestamp':
              (data['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
          'isRead': data['isRead'] ?? false,
        };
      }).toList();
    });
  }

  // Method to listen for chat updates in real-time
  Stream<List<Map<String, dynamic>>> getChatsStream() {
    final userEmail = _authController.getCurrentUserEmail();
    if (userEmail == null) {
      return Stream.value([]);
    }

    return _fireStore
        .collection("Chats")
        .where('participants', arrayContains: userEmail)
        .orderBy('lastMessageTime', descending: true)
        .snapshots()
        .asyncMap((snapshot) async {
      return Future.wait(snapshot.docs.map((doc) async {
        final data = doc.data();
        final participants = List<String>.from(data['participants'] ?? []);

        // Get the other participant's email
        final otherParticipantEmail = participants.firstWhere(
          (email) => email != userEmail,
          orElse: () => 'Unknown',
        );

        // Get username for the other participant
        final otherUsername = await getUsernameFromEmail(otherParticipantEmail);

        return {
          'chatId': doc.id,
          'participants': participants,
          'lastMessage': data['lastMessage'] ?? '',
          'lastMessageTime':
              (data['lastMessageTime'] as Timestamp?)?.toDate() ??
                  DateTime.now(),
          'unreadCount': data['unreadCount'] ?? 0,
          'otherParticipantEmail': otherParticipantEmail,
          'otherParticipantUsername': otherUsername,
        };
      }).toList());
    });
  }

  // Method to fetch all users from Supabase
  Future<void> fetchAllUsers() async {
    try {
      _loading = true;
      notifyListeners();

      final currentUserEmail = _authController.getCurrentUserEmail();
      if (currentUserEmail == null) return;

      final response = await _supabase
          .from('users')
          .select('id, email, username, avatar_url')
          .neq('email', currentUserEmail); // Exclude current user

      _allUsers = List<Map<String, dynamic>>.from(response);

      _loading = false;
      notifyListeners();
    } catch (error) {
      _loading = false;
      log('Error fetching users: $error');
      notifyListeners();
    }
  }

  // Method to upload an image to Supabase and send as a message
  Future<void> sendImageMessage(String recipientEmail, XFile imageFile) async {
    try {
      final userEmail = _authController.getCurrentUserEmail();
      if (userEmail == null) return;

      // Find or create a chat with the recipient
      final chatId = await _findOrCreateChat(userEmail, recipientEmail);
      _currentChatId = chatId;

      // Upload the image to Supabase
      final String imageUrl = await _uploadImageToSupabase(imageFile);

      if (imageUrl.isNotEmpty) {
        // Store the image message in Firebase
        await _storeImageMessageInFirebase(chatId, userEmail, imageUrl);

        // Update the chat's last message
        await _fireStore.collection("Chats").doc(chatId).update({
          'lastMessage': '📷 Image',
          'lastMessageTime': FieldValue.serverTimestamp(),
          'unreadCount': FieldValue.increment(1),
        });

        // Refresh messages
        await fetchMessages(chatId);
      }
    } catch (error) {
      log('Error sending image message: $error');
    }
  }

  // Helper method to upload an image to Supabase
  Future<String> _uploadImageToSupabase(XFile imageFile) async {
    try {
      final userEmail = _authController.getCurrentUserEmail();
      if (userEmail == null) return '';

      // Generate a unique file name
      final String fileName =
          '${DateTime.now().millisecondsSinceEpoch}_${path.basename(imageFile.path)}';

      // Upload the file to the 'chatimages' bucket
      final file = File(imageFile.path);
      final fileExtension = path.extension(imageFile.path).replaceAll('.', '');

      final response = await _supabase.storage.from('chatimages').upload(
            'chat/$userEmail/$fileName',
            file,
            fileOptions: FileOptions(
              contentType: 'image/$fileExtension',
              upsert: true,
            ),
          );

      // Get the public URL
      final imageUrl = _supabase.storage
          .from('chatimages')
          .getPublicUrl('chat/$userEmail/$fileName');

      return imageUrl;
    } catch (error) {
      log('Error uploading image to Supabase: $error');
      return '';
    }
  }

  // Helper method to store image message metadata in Firebase
  Future<void> _storeImageMessageInFirebase(
      String chatId, String senderEmail, String imageUrl) async {
    try {
      await _fireStore
          .collection("Chats")
          .doc(chatId)
          .collection("Messages")
          .add({
        'senderId': _authController.getCurrentUserId(),
        'senderEmail': senderEmail,
        'text': '',
        'imageUrl': imageUrl,
        'timestamp': FieldValue.serverTimestamp(),
        'isRead': false,
        'type': 'image',
      });
    } catch (error) {
      log('Error storing image message in Firebase: $error');
    }
  }

  // Method to send a text message
  Future<void> sendTextMessage(String recipientEmail, String text) async {
    try {
      final userEmail = _authController.getCurrentUserEmail();
      if (userEmail == null) return;

      // Find or create a chat with the recipient
      final chatId = await _findOrCreateChat(userEmail, recipientEmail);
      _currentChatId = chatId;

      // Add the message to the chat
      await _fireStore
          .collection("Chats")
          .doc(chatId)
          .collection("Messages")
          .add({
        'senderId': _authController.getCurrentUserId(),
        'senderEmail': userEmail,
        'text': text,
        'timestamp': FieldValue.serverTimestamp(),
        'isRead': false,
        'type': 'text',
      });

      // Update the chat's last message
      await _fireStore.collection("Chats").doc(chatId).update({
        'lastMessage': text,
        'lastMessageTime': FieldValue.serverTimestamp(),
        'unreadCount': FieldValue.increment(1),
      });

      // Refresh messages
      await fetchMessages(chatId);
    } catch (error) {
      log('Error sending message: $error');
    }
  }
}
