# Chat Feature Implementation

This directory contains the implementation of the chat feature for the Social Swap application.

## Overview

The chat feature allows users to:
- Send and receive messages in real-time
- View a list of all conversations
- Start new conversations with other users
- See unread message counts
- View message timestamps

## Implementation Details

### Files

1. **chat_services.dart**
   - Core service that handles all chat functionality
   - Manages communication with Firebase Firestore for message storage
   - Provides real-time updates using Firestore streams
   - Handles user information retrieval from Supabase

### Database Structure

The chat feature uses Firebase Firestore with the following structure:

- **Chats Collection**
  - Document ID: Unique chat ID
  - Fields:
    - `participants`: Array of user emails
    - `lastMessage`: Text of the most recent message
    - `lastMessageTime`: Timestamp of the most recent message
    - `unreadCount`: Number of unread messages
    - `createdAt`: When the chat was created

  - **Messages Subcollection**
    - Document ID: Unique message ID
    - Fields:
      - `senderId`: ID of the user who sent the message
      - `senderEmail`: Email of the user who sent the message
      - `text`: Message content
      - `timestamp`: When the message was sent
      - `isRead`: Boolean indicating if the message has been read

### User Information

User information is retrieved from Supabase:
- The username is extracted from the user's email (part before the @ symbol)
- This is cached for performance

## Usage

To use the chat feature in a new screen:

```dart
// Import the necessary files
import 'package:provider/provider.dart';
import 'package:social_swap/Controllers/Services/Chat/chat_services.dart';

// Access the chat service
final chatServices = Provider.of<ChatServices>(context, listen: false);

// Start a new chat
await chatServices.startNewChat('recipient@example.com');

// Send a message
await chatServices.sendMessage('recipient@example.com', 'Hello!');

// Get real-time updates for messages
StreamBuilder<List<Map<String, dynamic>>>(
  stream: chatServices.getMessagesStream(chatId),
  builder: (context, snapshot) {
    // Build UI with messages
  },
);
```

## Future Improvements

Potential enhancements for the chat feature:
- Add support for sending images and other media
- Implement typing indicators
- Add read receipts
- Support group chats
- Add message reactions
- Implement message search functionality