// ignore_for_file: use_build_context_synchronously, unnecessary_import

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:Konexea/Controllers/Services/Chat/chat_services.dart';
import 'package:Konexea/Controllers/Services/Authentication/authentication_controller.dart';
import 'package:intl/intl.dart';
// import 'package:shimmer/shimmer.dart';
import 'package:Konexea/Views/Auth%20Gate/auth_gate.dart';

// Import components
import 'package:Konexea/Views/Components/Chat/chat_list_item.dart';
import 'package:Konexea/Views/Components/Chat/message_bubble.dart';
import 'package:Konexea/Views/Components/Chat/message_composer.dart';
// import 'package:Konexea/Views/Components/Chat/chat_app_bar.dart';
import 'package:Konexea/Views/Components/Chat/empty_states.dart';

class ChatPage extends StatefulWidget {
  final String? recipientEmail;

  const ChatPage({super.key, this.recipientEmail});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final AuthenticationController _authController = AuthenticationController();
  late ChatServices _chatServices;
  // ignore: unused_field
  bool _isComposing = false;
  String? _currentChatId;
  String? _currentUserEmail;

  @override
  void initState() {
    super.initState();
    _currentUserEmail = _authController.getCurrentUserEmail();

    // Initialize chat services
    Future.microtask(() {
      _chatServices = Provider.of<ChatServices>(context, listen: false);
      _initializeChat();
    });
  }

  Future<void> _initializeChat() async {
    // If a recipient email is provided, start a new chat with that user
    if (widget.recipientEmail != null) {
      await _chatServices.startNewChat(widget.recipientEmail!);
      setState(() {
        _currentChatId = _chatServices.currentChatId;
      });
    } else {
      // Otherwise, fetch all chats
      await _chatServices.fetchChats();
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  Future<void> _handleSendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    // Clear the input field
    _messageController.clear();
    setState(() {
      _isComposing = false;
    });

    // If we're in a chat, send the message
    if (_currentChatId != null) {
      // Get the recipient email from the current chat
      final chat = _chatServices.chats.firstWhere(
        (chat) => chat['chatId'] == _currentChatId,
        orElse: () => {'participants': []},
      );

      final participants = List<String>.from(chat['participants'] ?? []);
      final recipientEmail = participants.firstWhere(
        (email) => email != _currentUserEmail,
        orElse: () => widget.recipientEmail ?? '',
      );

      if (recipientEmail.isNotEmpty) {
        await _chatServices.sendMessage(recipientEmail, text);
        // Scroll to the bottom after sending
        Future.delayed(const Duration(milliseconds: 100), _scrollToBottom);
      }
    } else if (widget.recipientEmail != null) {
      // If we're starting a new chat
      await _chatServices.sendMessage(widget.recipientEmail!, text);
      setState(() {
        _currentChatId = _chatServices.currentChatId;
      });
      // Scroll to the bottom after sending
      Future.delayed(const Duration(milliseconds: 100), _scrollToBottom);
    }
  }

  Widget _buildChatList() {
    return Consumer<ChatServices>(
      builder: (context, chatServices, _) {
        if (chatServices.loading) {
          return EmptyStates.buildLoadingShimmer(context);
        }

        if (chatServices.chats.isEmpty) {
          return EmptyStates.buildEmptyChatsState(context, _showNewChatDialog);
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          itemCount: chatServices.chats.length,
          itemBuilder: (context, index) {
            final chat = chatServices.chats[index];
            return ChatListItem(
              chat: chat,
              onChatSelected: (chatId) {
                setState(() {
                  _currentChatId = chatId;
                });
                _chatServices.fetchMessages(chatId);
              },
              formatChatTime: _formatChatTime,
            );
          },
        );
      },
    );
  }

  Widget _buildChatMessages() {
    return Consumer<ChatServices>(
      builder: (context, chatServices, _) {
        if (chatServices.loading) {
          return EmptyStates.buildLoadingShimmer(context);
        }

        if (_currentChatId == null) {
          return EmptyStates.buildSelectChatPrompt(context);
        }

        // Use StreamBuilder for real-time updates
        return StreamBuilder<List<Map<String, dynamic>>>(
          stream: chatServices.getMessagesStream(_currentChatId!),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting &&
                !snapshot.hasData) {
              return EmptyStates.buildLoadingShimmer(context);
            }

            final messages = snapshot.data ?? chatServices.messages;

            if (messages.isEmpty) {
              return EmptyStates.buildEmptyChatState(context);
            }

            // Scroll to bottom when new messages arrive
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _scrollToBottom();
            });

            return ListView.builder(
              controller: _scrollController,
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                final isCurrentUser =
                    message['senderEmail'] == _currentUserEmail;
                return MessageBubble(
                  message: message,
                  isCurrentUser: isCurrentUser,
                  currentUserEmail: _currentUserEmail,
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildMessageComposer() {
    return MessageComposer(
      controller: _messageController,
      onSendMessage: _handleSendMessage,
    );
  }

  // Empty state widgets have been moved to the EmptyStates class

  void _showNewChatDialog() {
    final TextEditingController emailController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Start a new chat',
          style: GoogleFonts.urbanist(fontWeight: FontWeight.bold),
        ),
        content: TextField(
          controller: emailController,
          decoration: InputDecoration(
            hintText: 'Enter email address',
            hintStyle: GoogleFonts.urbanist(),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          keyboardType: TextInputType.emailAddress,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: GoogleFonts.urbanist(),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              final email = emailController.text.trim();
              if (email.isNotEmpty) {
                Navigator.pop(context);
                _chatServices.startNewChat(email).then((_) {
                  setState(() {
                    _currentChatId = _chatServices.currentChatId;
                  });
                });
              }
            },
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: Text(
              'Start Chat',
              style: GoogleFonts.urbanist(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  String _formatChatTime(DateTime time) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final messageDate = DateTime(time.year, time.month, time.day);

    if (messageDate == today) {
      return DateFormat('h:mm a').format(time);
    } else if (messageDate == yesterday) {
      return 'Yesterday';
    } else if (now.difference(time).inDays < 7) {
      return DateFormat('EEEE').format(time); // Day name
    } else {
      return DateFormat('MMM d').format(time); // Month and day
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Iconsax.arrow_left),
          onPressed: () {
            Navigator.of(context).pop(_elegantRoute(const AuthGate()));
            _chatServices.fetchChats();
          },
        ),
        title: Text(
          'Chats',
          style: GoogleFonts.urbanist(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          image: const DecorationImage(
            image: AssetImage('assets/images/chat_background.png'),
            fit: BoxFit.cover,
            opacity: 0.05,
          ),
        ),
        child: Column(
          children: [
            // Main content - either chat list or messages
            Expanded(
              child: _currentChatId != null
                  ? _buildChatMessages()
                  : _buildChatList(),
            ),

            // Message composer - only show when in a chat
            if (_currentChatId != null) _buildMessageComposer(),
          ],
        ),
      ),
      floatingActionButton: _currentChatId == null
          ? FloatingActionButton.extended(
              onPressed: _showNewChatDialog,
              icon: const Icon(Iconsax.message_add),
              label: Text(
                'New Chat',
                style: GoogleFonts.urbanist(fontWeight: FontWeight.bold),
              ),
              elevation: 2,
            )
          : null,
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Route _elegantRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.easeInOutCubic;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 500),
    );
  }
}
