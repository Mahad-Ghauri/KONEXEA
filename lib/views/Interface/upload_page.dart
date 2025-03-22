// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:social_swap/controllers/Services/Database/feed_services.dart';
import 'package:social_swap/controllers/input_controllers.dart';
import 'package:social_swap/views/components/auth_button.dart';

class UploadPage extends StatefulWidget {
  const UploadPage({super.key});

  @override
  State<UploadPage> createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  //  Input Controllers instance
  final InputControllers inputControllers = InputControllers();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(color: Colors.black.withOpacity(0.5)),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.sizeOf(context).width * 0.025,
            ),

            child: Column(
              children: [
                const SizedBox(height: 20),
                Expanded(
                  flex: 1,
                  child: Consumer<FeedServices>(
                    builder: (context, value, child) {
                      return GestureDetector(
                        onTap: () => value.pickImageFromGallery(),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Theme.of(
                              context,
                            ).colorScheme.surface.withOpacity(0.65),
                            border: Border.all(
                              color: Colors.black87.withOpacity(0.6),
                            ),
                          ),
                          width: double.infinity,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Center(
                              child:
                                  value.image != null
                                      ? Image.file(
                                        value.image!,
                                        fit: BoxFit.cover,
                                      )
                                      : Icon(
                                        Iconsax.gallery,
                                        color:
                                            Theme.of(
                                              context,
                                            ).colorScheme.primary,
                                      ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Text(
                              'Tell us what\'s on your mind?',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        Form(
                          key: inputControllers.formKey,
                          child: TextFormField(
                            style: TextStyle(color: Colors.white),
                            maxLines: 5,
                            validator: (value) {
                              if (value == null) {
                                return "Please Enter a Description";
                              } else {
                                return null;
                              }
                            },
                            controller: inputControllers.descriptionController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(18),
                                borderSide: BorderSide(
                                  color: Colors.black87.withOpacity(0.6),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                borderRadius: BorderRadius.circular(18),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(18),
                                borderSide: BorderSide(
                                  color: Colors.black87.withOpacity(0.6),
                                ),
                              ),
                              filled: true,
                              fillColor: Theme.of(
                                context,
                              ).colorScheme.surface.withOpacity(0.55),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Consumer<FeedServices>(
                          builder: (context, value, child) {
                            return AuthButton(
                              isLoading: inputControllers.loading,
                              onPressed: () {
                                if (inputControllers.formKey.currentState!
                                    .validate()) {
                                  value.uploadDataToDatabase(
                                    inputControllers.descriptionController,
                                    context,
                                  );
                                } else {
                                  return;
                                }
                              },
                              text: 'Post',
                            );
                          },
                        ),
                      ],
                    ),
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
