import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:social_swap/views/Auth%20Gate/auth_gate.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _CharPageState();
}

class _CharPageState extends State<ChatPage> {
  void _showLiveChatModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.headset_mic,
                size: 64,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 16),
              Text(
                'Chat feature',
                style: GoogleFonts.urbanist(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'This feature will be available in the next update.',
                style: GoogleFonts.urbanist(fontSize: 16),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => Navigator.of(context)
                    .push(MaterialPageRoute(builder: (_) => const AuthGate())),
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Text(
                  'Close',
                  style: GoogleFonts.urbanist(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),  
    );
  }

  @override
  Widget build(BuildContext context) {
    // Show modal after the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showLiveChatModal();
    });

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Chat Page',
          style: TextStyle(
            fontFamily: GoogleFonts.outfit().fontFamily,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
      body: const Center(
        child: Text('Chat content will go here'),
      ),
    );
  }
}
