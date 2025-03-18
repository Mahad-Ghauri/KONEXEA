// import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:social_swap/controllers/Services/Database/feed_services.dart';
import 'package:social_swap/controllers/input_controllers.dart';
import 'package:social_swap/views/components/auth_button.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({super.key});

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  final InputControllers inputControllers = InputControllers();
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;
    // final width = MediaQuery.sizeOf(context).width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Feed',
          style: GoogleFonts.urbanist(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Iconsax.document_upload, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Consumer<FeedServices>(
            builder: (context, value, child) {
              return GestureDetector(
                onTap: () => value.pickImageFromGallery(),
                child: Container(
                  height: height * 0.3,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                  ),
                  child: Center(
                    child:
                        value.image != null
                            ? Image.file(value.image!)
                            : Icon(Iconsax.wallet_minus
                            , color: Colors.black),
                  ),
                ),
              );
            },
          ),

          SizedBox(height: height * 0.01),
          TextField(
            controller: inputControllers.descriptionController,
            maxLines: 4,
            decoration: InputDecoration(border: OutlineInputBorder()),
          ),
          SizedBox(height: height * 0.01),
          Consumer<FeedServices>(
            builder: (context, value, child) {
              return AuthButton(
                onPressed:
                    () => value.uploadDataToDatabase(
                      inputControllers.descriptionController,
                      context,
                    ),
                text: "Post",
              );
            },
          ),
        ],
      ),
    );
  }
}
