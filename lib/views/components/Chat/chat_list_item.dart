// ignore_for_file: use_super_parameters, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatListItem extends StatelessWidget {
  final Map<String, dynamic> chat;
  final Function(String) onChatSelected;
  final String Function(DateTime) formatChatTime;

  const ChatListItem({
    Key? key,
    required this.chat,
    required this.onChatSelected,
    required this.formatChatTime,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final otherUsername = chat['otherParticipantUsername'] ?? 'User';
    final lastMessage = chat['lastMessage'] ?? '';
    final lastMessageTime = chat['lastMessageTime'] as DateTime? ?? DateTime.now();
    final unreadCount = chat['unreadCount'] ?? 0;
    final formattedTime = formatChatTime(lastMessageTime);
    
    return Card(
      elevation: 0.5,
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        onTap: () => onChatSelected(chat['chatId']),
        leading: CircleAvatar(
          radius: 24,
          backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
          child: Text(
            otherUsername.isNotEmpty ? otherUsername[0].toUpperCase() : '?',
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
              fontSize: 16,
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
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Text(
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
      ),
    );
  }
}