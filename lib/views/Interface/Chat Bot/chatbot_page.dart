// ignore_for_file: deprecated_member_use, unused_local_variable

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:Konexea/controllers/Services/API/Chatbot/chatbot_services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:lottie/lottie.dart';

class ChatbotPage extends StatefulWidget {
  const ChatbotPage({super.key});

  @override
  State<ChatbotPage> createState() => _ChatbotPageState();
}

class _ChatbotPageState extends State<ChatbotPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Theme.of(context).colorScheme.surface,
                  Theme.of(context).colorScheme.surface.withOpacity(0.95),
                  Theme.of(context).colorScheme.surface.withOpacity(0.9),
                ],
              ),
            ),
          ),

          // Chat content
          SafeArea(
            child: Column(
              children: [
                // App bar
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Theme.of(context).colorScheme.surface.withOpacity(0.8),
                        Theme.of(context).colorScheme.surface.withOpacity(0.6),
                      ],
                    ),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.arrow_back_ios_new,
                          color: Theme.of(context).colorScheme.tertiary,
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const SizedBox(width: 12),
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: Theme.of(
                          context,
                        ).colorScheme.primary.withOpacity(0.1),
                        child: Icon(
                          Icons.smart_toy_outlined,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Konexea',
                            style: GoogleFonts.urbanist(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).colorScheme.tertiary,
                            ),
                          ),
                          Text(
                            'Keep up with the trends',
                            style: GoogleFonts.urbanist(
                              fontSize: 14,
                              color: Theme.of(
                                context,
                              ).colorScheme.tertiary.withOpacity(0.5),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Messages list
                Expanded(
                  child: Consumer<ChatbotController>(
                    builder: (context, chatbot, _) {
                      return ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.all(16),
                        itemCount: chatbot.messages.length,
                        itemBuilder: (context, index) {
                          final message = chatbot.messages[index];
                          final isUser = message['sender'] == 'user';
                          final isLastMessage =
                              index == chatbot.messages.length - 1;

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: Row(
                              mainAxisAlignment: isUser
                                  ? MainAxisAlignment.end
                                  : MainAxisAlignment.start,
                              children: [
                                if (!isUser) ...[
                                  SizedBox(
                                    width: 35,
                                    height: 35,
                                    child: Lottie.asset(
                                      'assets/lottie/ai.json',
                                      fit: BoxFit.contain,
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              const Icon(Icons.android,
                                                  color: Colors.green,
                                                  size: 35),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                ],
                                Flexible(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 12,
                                    ),
                                    decoration: BoxDecoration(
                                      // The color of the container of the user text
                                      color: isUser
                                          ? Theme.of(
                                              context,
                                            )
                                              .colorScheme
                                              .primary
                                              .withOpacity(0.7)
                                          : Theme.of(
                                              context,
                                            )
                                              .colorScheme
                                              .primary
                                              .withOpacity(0.7),
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          blurRadius: 5,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      crossAxisAlignment: isUser
                                          ? CrossAxisAlignment.end
                                          : CrossAxisAlignment.start,
                                      children: [
                                        //Color of the text of the user and chatbot in the basis of the condition
                                        Text(
                                          message['text'] ?? '',
                                          style: GoogleFonts.urbanist(
                                            fontWeight: FontWeight.bold,
                                            color: isUser
                                                ? Theme.of(context)
                                                    .colorScheme
                                                    .surface
                                                : Theme.of(
                                                    context,
                                                  ).colorScheme.surface,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                if (isUser) ...[
                                  const SizedBox(width: 8),
                                  CircleAvatar(
                                    radius: 16,
                                    backgroundColor: Theme.of(
                                      context,
                                    ).colorScheme.primary.withOpacity(0.5),
                                    child: Icon(
                                      Iconsax.profile_circle,
                                      size: 16,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),

                // Input field
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color:
                        Theme.of(context).colorScheme.primary.withOpacity(0.8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, -5),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _messageController,
                          style: GoogleFonts.urbanist(
                            color: Theme.of(context).colorScheme.tertiary,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Type your message...',
                            hintStyle: GoogleFonts.urbanist(
                              color: Theme.of(
                                context,
                              ).colorScheme.tertiary,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: Theme.of(
                              context,
                            ).colorScheme.surface,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Consumer<ChatbotController>(
                        builder: (context, chatbot, _) {
                          return FloatingActionButton(
                            onPressed: chatbot.isLoading
                                ? null
                                : () {
                                    if (_messageController.text
                                        .trim()
                                        .isNotEmpty) {
                                      chatbot.fetchResponse(
                                        _messageController.text.trim(),
                                      );
                                      _messageController.clear();
                                      _scrollToBottom();
                                    }
                                  },
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                            child: Icon(
                              chatbot.isLoading
                                  ? Iconsax.timer
                                  : Iconsax.send_1,
                              color: Theme.of(context).colorScheme.surface,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
