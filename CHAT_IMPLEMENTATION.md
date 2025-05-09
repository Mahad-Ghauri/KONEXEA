# Chat Feature Implementation

## Overview

This document outlines the implementation of the chat feature for the Social Swap application. The chat feature allows users to send and receive messages in real-time, view conversations, and interact with other users.

## Files Created/Modified

1. **New Files:**
   - `lib/Controllers/Services/Chat/chat_services.dart` - Core service for chat functionality
   - `lib/Views/Interface/Chat/chat_list_page.dart` - Page to display all chats
   - `lib/Controllers/Services/Chat/README.md` - Documentation for the chat feature

2. **Modified Files:**
   - `lib/Views/Interface/chat_page.dart` - Updated to implement chat functionality
   - `lib/main.dart` - Added ChatServices provider

## Features Implemented

- **Real-time Messaging:** Users can send and receive messages in real-time
- **Chat List:** View all conversations with other users
- **Message Status:** Track read/unread status of messages
- **User Information:** Display usernames extracted from email addresses
- **Timestamps:** Show when messages were sent
- **New Chat Creation:** Start conversations with other users

## Technical Implementation

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

### Real-time Updates

The chat feature uses Firestore streams to provide real-time updates:
- `getMessagesStream()` - Provides real-time updates for messages in a chat
- `getChatsStream()` - Provides real-time updates for the list of chats

## UI Components

1. **Chat List:**
   - Displays all conversations
   - Shows the other participant's username
   - Displays the last message and timestamp
   - Indicates unread message count

2. **Chat Interface:**
   - Message bubbles for sent and received messages
   - Message composer with text input
   - Real-time updates as messages are sent/received
   - Visual indicators for message status

3. **New Chat Dialog:**
   - Allows users to start a new conversation by entering an email address

## How to Use

1. **View Chats:**
   - Navigate to the Chat page from the main interface
   - See a list of all conversations

2. **Send a Message:**
   - Select a chat or start a new one
   - Type a message in the composer
   - Tap the send button

3. **Start a New Chat:**
   - Tap the floating action button
   - Enter the recipient's email address
   - Start sending messages

## Future Improvements

Potential enhancements for the chat feature:
- Add support for sending images and other media
- Implement typing indicators
- Add read receipts
- Support group chats
- Add message reactions
- Implement message search functionality