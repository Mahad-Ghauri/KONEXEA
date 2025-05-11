import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:social_swap/Controllers/Services/Chat/chat_services.dart';

class ChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? currentChatId;
  final VoidCallback onBackPressed;
  
  const ChatAppBar({
    Key? key,
    required this.currentChatId,
    required this.onBackPressed,
  }) : super(key: key);
  
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
  
  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0.5,
      backgroundColor: Theme.of(context).colorScheme.surface,
      centerTitle: false,
      title: _buildTitle(context),
      leading: currentChatId != null
          ? IconButton(
              icon: const Icon(Iconsax.arrow_left),
              onPressed: onBackPressed,
            )
          : _buildLogo(context),
      leadingWidth: currentChatId != null ? 56 : 80,
      actions: [
        if (currentChatId != null)
          IconButton(
            icon: const Icon(Iconsax.info_circle),
            onPressed: () {
              // Chat info functionality could be added here
              HapticFeedback.lightImpact();
            },
          ),
        if (currentChatId == null)
          IconButton(
            icon: const Icon(Iconsax.search_normal),
            onPressed: () {
              // Search functionality could be added here
              HapticFeedback.lightImpact();
            },
          ),
      ],
    );
  }
  
  Widget _buildTitle(BuildContext context) {
    if (currentChatId != null) {
      return Consumer<ChatServices>(
        builder: (context, chatServices, _) {
          final chat = chatServices.chats.firstWhere(
            (chat) => chat['chatId'] == currentChatId,
            orElse: () => {'otherParticipantUsername': 'Chat'},
          );
          
          return Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                child: Text(
                  chat['otherParticipantUsername']?.toString().isNotEmpty == true 
                      ? chat['otherParticipantUsername'][0].toUpperCase() 
                      : '?',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    chat['otherParticipantUsername'] ?? 'Chat',
                    style: GoogleFonts.urbanist(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  Text(
                    'Online',
                    style: GoogleFonts.urbanist(
                      fontSize: 12,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      );
    } else {
      return Text(
        'Chats',
        style: GoogleFonts.urbanist(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.primary,
        ),
      );
    }
  }
  
  Widget _buildLogo(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0),
      child: Container(
        alignment: Alignment.centerLeft,
        child: Image.asset(
          'assets/images/logo.png',
          height: 32,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}