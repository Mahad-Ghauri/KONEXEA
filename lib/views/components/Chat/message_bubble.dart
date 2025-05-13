// ignore_for_file: use_super_parameters, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class MessageBubble extends StatelessWidget {
  final Map<String, dynamic> message;
  final bool isCurrentUser;
  final String? currentUserEmail;

  const MessageBubble({
    Key? key,
    required this.message,
    required this.isCurrentUser,
    this.currentUserEmail,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final text = message['text'] ?? '';
    final timestamp = message['timestamp'] as DateTime? ?? DateTime.now();
    final formattedTime = DateFormat('h:mm a').format(timestamp);
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: isCurrentUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isCurrentUser)
            _buildAvatar(
              context, 
              message['senderEmail']?.toString() ?? '',
              Theme.of(context).colorScheme.surface.withOpacity(0.2),
              Theme.of(context).colorScheme.surface,
            ),
          if (!isCurrentUser) const SizedBox(width: 8),
          
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
              decoration: BoxDecoration(
                color: isCurrentUser 
                    ? Theme.of(context).colorScheme.primary 
                    : Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(20),
                  topRight: const Radius.circular(20),
                  bottomLeft: isCurrentUser ? const Radius.circular(20) : const Radius.circular(5),
                  bottomRight: isCurrentUser ? const Radius.circular(5) : const Radius.circular(20),
                ),
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
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        formattedTime,
                        style: GoogleFonts.urbanist(
                          color: isCurrentUser 
                              ? Colors.white.withOpacity(0.7) 
                              : Theme.of(context).textTheme.bodySmall?.color,
                          fontSize: 10,
                        ),
                      ),
                      if (isCurrentUser) ...[
                        const SizedBox(width: 4),
                        Icon(
                          Icons.check,
                          size: 12,
                          color: Colors.white.withOpacity(0.7),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),
          
          if (isCurrentUser) const SizedBox(width: 8),
          if (isCurrentUser)
            _buildAvatar(
              context, 
              currentUserEmail ?? '',
              Theme.of(context).colorScheme.primary.withOpacity(0.2),
              Theme.of(context).colorScheme.primary,
            ),
        ],
      ),
    );
  }
  
  Widget _buildAvatar(BuildContext context, String email, Color backgroundColor, Color textColor) {
    return CircleAvatar(
      radius: 16,
      backgroundColor: backgroundColor,
      child: Text(
        email.isNotEmpty ? email[0].toUpperCase() : '?',
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }
}