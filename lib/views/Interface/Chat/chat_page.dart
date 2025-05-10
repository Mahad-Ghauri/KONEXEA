import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:social_swap/Controllers/Services/Chat/chat_services.dart';
import 'package:social_swap/Controllers/Services/Authentication/authentication_controller.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

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
          return _buildLoadingShimmer();
        }
        
        if (chatServices.chats.isEmpty) {
          return _buildEmptyState();
        }
        
        return ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          itemCount: chatServices.chats.length,
          itemBuilder: (context, index) {
            final chat = chatServices.chats[index];
            return _buildChatListItem(chat);
          },
        );
      },
    );
  }
  
  Widget _buildChatListItem(Map<String, dynamic> chat) {
    final otherUsername = chat['otherParticipantUsername'] ?? 'User';
    final lastMessage = chat['lastMessage'] ?? '';
    final lastMessageTime = chat['lastMessageTime'] as DateTime? ?? DateTime.now();
    final unreadCount = chat['unreadCount'] ?? 0;
    final formattedTime = _formatChatTime(lastMessageTime);
    
    return ListTile(
      onTap: () {
        setState(() {
          _currentChatId = chat['chatId'];
        });
        _chatServices.fetchMessages(chat['chatId']);
      },
      leading: CircleAvatar(
        backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
        child: Text(
          otherUsername.isNotEmpty ? otherUsername[0].toUpperCase() : '?',
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      title: Text(
        otherUsername,
        style: GoogleFonts.urbanist(
          fontWeight: unreadCount > 0 ? FontWeight.bold : FontWeight.normal,
          fontSize: 16,
        ),
      ),
      subtitle: Text(
        lastMessage,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: GoogleFonts.urbanist(
          color: unreadCount > 0 
              ? Theme.of(context).colorScheme.primary 
              : Theme.of(context).textTheme.bodyMedium?.color,
          fontWeight: unreadCount > 0 ? FontWeight.w500 : FontWeight.normal,
        ),
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            formattedTime,
            style: GoogleFonts.urbanist(
              fontSize: 12,
              color: unreadCount > 0 
                  ? Theme.of(context).colorScheme.primary 
                  : Theme.of(context).textTheme.bodySmall?.color,
            ),
          ),
          if (unreadCount > 0)
            Container(
              margin: const EdgeInsets.only(top: 4),
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                shape: BoxShape.circle,
              ),
              child: Text(
                unreadCount.toString(),
                style: GoogleFonts.urbanist(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }
  
  Widget _buildChatMessages() {
    return Consumer<ChatServices>(
      builder: (context, chatServices, _) {
        if (chatServices.loading) {
          return _buildLoadingShimmer();
        }
        
        if (_currentChatId == null) {
          return _buildSelectChatPrompt();
        }
        
        // Use StreamBuilder for real-time updates
        return StreamBuilder<List<Map<String, dynamic>>>(
          stream: chatServices.getMessagesStream(_currentChatId!),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting && !snapshot.hasData) {
              return _buildLoadingShimmer();
            }
            
            final messages = snapshot.data ?? chatServices.messages;
            
            if (messages.isEmpty) {
              return _buildEmptyChatState();
            }
            
            // Scroll to bottom when new messages arrive
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _scrollToBottom();
            });
            
            return ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                final isCurrentUser = message['senderEmail'] == _currentUserEmail;
                return _buildMessageBubble(message, isCurrentUser);
              },
            );
          },
        );
      },
    );
  }
  
  Widget _buildMessageBubble(Map<String, dynamic> message, bool isCurrentUser) {
    final text = message['text'] ?? '';
    final timestamp = message['timestamp'] as DateTime? ?? DateTime.now();
    final formattedTime = DateFormat('h:mm a').format(timestamp);
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: isCurrentUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isCurrentUser)
            CircleAvatar(
              radius: 16,
              backgroundColor: Theme.of(context).colorScheme.surface.withOpacity(0.2),
              child: Text(
                message['senderEmail']?.toString().isNotEmpty == true 
                    ? message['senderEmail'][0].toUpperCase() 
                    : '?',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.surface,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          if (!isCurrentUser) const SizedBox(width: 8),
          
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
              decoration: BoxDecoration(
                color: isCurrentUser 
                    ? Theme.of(context).colorScheme.primary 
                    : Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    text,
                    style: GoogleFonts.urbanist(
                      color: isCurrentUser 
                          ? Colors.white 
                          : Theme.of(context).textTheme.bodyMedium?.color,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    formattedTime,
                    style: GoogleFonts.urbanist(
                      color: isCurrentUser 
                          ? Colors.white.withOpacity(0.7) 
                          : Theme.of(context).textTheme.bodySmall?.color,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          if (isCurrentUser) const SizedBox(width: 8),
          if (isCurrentUser)
            CircleAvatar(
              radius: 16,
              backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
              child: Text(
                _currentUserEmail?.isNotEmpty == true 
                    ? _currentUserEmail![0].toUpperCase() 
                    : '?',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
        ],
      ),
    );
  }
  
  Widget _buildMessageComposer() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Iconsax.emoji_happy),
            onPressed: () {
              // Emoji picker functionality could be added here
              HapticFeedback.lightImpact();
            },
          ),
          Expanded(
            child: TextField(
              controller: _messageController,
              textCapitalization: TextCapitalization.sentences,
              onChanged: (text) {
                setState(() {
                  _isComposing = text.trim().isNotEmpty;
                });
              },
              decoration: InputDecoration(
                hintText: 'Type a message...',
                hintStyle: GoogleFonts.urbanist(),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Theme.of(context).colorScheme.surface.withOpacity(0.8),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              ),
            ),
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            child: _isComposing
                ? IconButton(
                    icon: Icon(
                      Iconsax.send_1,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    onPressed: _handleSendMessage,
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Iconsax.camera),
                        onPressed: () {
                          // Image picker functionality could be added here
                          HapticFeedback.lightImpact();
                        },
                      ),
                      IconButton(
                        icon: const Icon(Iconsax.microphone_2),
                        onPressed: () {
                          // Voice message functionality could be added here
                          HapticFeedback.lightImpact();
                        },
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildLoadingShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListView.builder(
        itemCount: 10,
        padding: const EdgeInsets.all(16.0),
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        height: 12,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.6,
                        height: 12,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
  
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Iconsax.message_text_1,
            size: 64,
            color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'No conversations yet',
            style: GoogleFonts.urbanist(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Start chatting with friends',
            style: GoogleFonts.urbanist(
              fontSize: 16,
              color: Theme.of(context).textTheme.bodySmall?.color,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              // Show user list or search functionality could be added here
              _showNewChatDialog();
            },
            icon: const Icon(Iconsax.add),
            label: Text(
              'New Chat',
              style: GoogleFonts.urbanist(fontWeight: FontWeight.bold),
            ),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildEmptyChatState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Iconsax.message_text,
            size: 64,
            color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'No messages yet',
            style: GoogleFonts.urbanist(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Send a message to start the conversation',
            style: GoogleFonts.urbanist(
              fontSize: 16,
              color: Theme.of(context).textTheme.bodySmall?.color,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
  
  Widget _buildSelectChatPrompt() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Iconsax.message_question,
            size: 64,
            color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'Select a conversation',
            style: GoogleFonts.urbanist(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Choose a chat from the list or start a new one',
            style: GoogleFonts.urbanist(
              fontSize: 16,
              color: Theme.of(context).textTheme.bodySmall?.color,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
  
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
        centerTitle: true,
        title: _currentChatId != null && _chatServices.chats.isNotEmpty
            ? Consumer<ChatServices>(
                builder: (context, chatServices, _) {
                  final chat = chatServices.chats.firstWhere(
                    (chat) => chat['chatId'] == _currentChatId,
                    orElse: () => {'otherParticipantUsername': 'Chat'},
                  );
                  
                  return Text(
                    chat['otherParticipantUsername'] ?? 'Chat',
                    style: TextStyle(
                      fontFamily: GoogleFonts.outfit().fontFamily,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  );
                },
              )
            : Text(
                'Chats',
                style: TextStyle(
                  fontFamily: GoogleFonts.outfit().fontFamily,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
        leading: _currentChatId != null
            ? IconButton(
                icon: const Icon(Iconsax.arrow_left),
                onPressed: () {
                  setState(() {
                    _currentChatId = null;
                  });
                },
              )
            : null,
        actions: [
          if (_currentChatId != null)
            IconButton(
              icon: const Icon(Iconsax.info_circle),
              onPressed: () {
                // Chat info functionality could be added here
                HapticFeedback.lightImpact();
              },
            ),
        ],
      ),
      body: Column(
        children: [
          // Main content - either chat list or messages
          Expanded(
            child: _currentChatId != null ? _buildChatMessages() : _buildChatList(),
          ),
          
          // Message composer - only show when in a chat
          if (_currentChatId != null) _buildMessageComposer(),
        ],
      ),
      floatingActionButton: _currentChatId == null
          ? FloatingActionButton(
              onPressed: _showNewChatDialog,
              child: const Icon(Iconsax.message_add),
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
}
