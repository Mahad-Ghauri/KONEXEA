// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';

class MessageComposer extends StatefulWidget {
  final TextEditingController controller;
  final Function() onSendMessage;
  
  const MessageComposer({
    super.key,
    required this.controller,
    required this.onSendMessage,
  });

  @override
  State<MessageComposer> createState() => _MessageComposerState();
}

class _MessageComposerState extends State<MessageComposer> {
  bool _isComposing = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_updateComposingState);
  }

  void _updateComposingState() {
    final isComposing = widget.controller.text.trim().isNotEmpty;
    if (isComposing != _isComposing) {
      setState(() {
        _isComposing = isComposing;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
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
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Iconsax.emoji_happy),
              color: Theme.of(context).colorScheme.primary,
              onPressed: () {
                // Emoji picker functionality could be added here
                HapticFeedback.lightImpact();
              },
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface.withOpacity(0.8),
                borderRadius: BorderRadius.circular(24.0),
                border: Border.all(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                  width: 1.0,
                ),
              ),
              child: TextField(
                controller: widget.controller,
                textCapitalization: TextCapitalization.sentences,
                minLines: 1,
                maxLines: 5,
                decoration: InputDecoration(
                  hintText: 'Type a message...',
                  hintStyle: GoogleFonts.urbanist(),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: _isComposing 
                  ? Theme.of(context).colorScheme.primary 
                  : Theme.of(context).colorScheme.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: _isComposing
                ? IconButton(
                    icon: const Icon(
                      Iconsax.send_1,
                      color: Colors.white,
                    ),
                    onPressed: widget.onSendMessage,
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(
                          Iconsax.camera,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        onPressed: () {
                          // Image picker functionality could be added here
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
  
  @override
  void dispose() {
    widget.controller.removeListener(_updateComposingState);
    super.dispose();
  }
}