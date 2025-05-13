// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:Konexea/Controllers/Services/Feed%20Database/feed_services.dart';
import 'package:Konexea/controllers/input_controllers.dart';
import 'package:Konexea/views/components/auth_button.dart';
import 'package:google_fonts/google_fonts.dart';

class UploadPage extends StatefulWidget {
  const UploadPage({super.key});

  @override
  State<UploadPage> createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage>
    with SingleTickerProviderStateMixin {
  final InputControllers inputControllers = InputControllers();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_animationController);
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        // leading: Icon(
        //   FontAwesomeIcons.infinity,
        //   color: Theme.of(context).colorScheme.primary,
        // ),
        title: const Text('Upload page'),
        titleTextStyle: TextStyle(
          color: Theme.of(context).colorScheme.tertiary,
          fontSize: height * 0.024,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.5,
          fontFamily: GoogleFonts.lobsterTwo().fontFamily,
        ),
      ),
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          // Enhanced background gradient
          // Container(
          //   decoration: BoxDecoration(
          //     gradient: LinearGradient(
          //       begin: Alignment.topLeft,
          //       end: Alignment.bottomRight,
          //       colors: [
          //         Colors.black.withOpacity(0.2),
          //         Colors.black.withOpacity(0.2),
          //         Colors.black.withOpacity(0.2),
          //       ],
          //     ),
          //   ),
          // ),

          // Content
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: width * 0.025),
              child: Column(
                children: [
                  SizedBox(height: height * 0.02),
                  Expanded(
                    flex: 1,
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: Consumer<FeedServices>(
                        builder: (context, value, child) {
                          return GestureDetector(
                            onTap: () => value.pickImageFromGallery(),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .tertiary
                                        .withOpacity(0.3),
                                    blurRadius: 10,
                                    // offset: const Offset(0, 4),
                                  ),
                                ],
                                gradient: LinearGradient(
                                  colors: [
                                    Theme.of(
                                      context,
                                    ).colorScheme.surface.withOpacity(0.8),
                                    Theme.of(
                                      context,
                                    ).colorScheme.surface.withOpacity(0.6),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                              ),
                              width: double.infinity,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Center(
                                  child: value.image != null
                                      ? Image.file(
                                          value.image!,
                                          fit: BoxFit.cover,
                                        )
                                      : Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Iconsax.gallery,
                                              size: 48,
                                              color: Theme.of(
                                                context,
                                              ).colorScheme.primary,
                                            ),
                                            const SizedBox(height: 12),
                                            Text(
                                              'Tap to add image',
                                              style: GoogleFonts.urbanist(
                                                color: Theme.of(
                                                  context,
                                                ).colorScheme.primary,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Align(
                              alignment: Alignment.topLeft,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                ),
                                child: Text(
                                  'Tell us what\'s on your mind?',
                                  style: GoogleFonts.urbanist(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.tertiary,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            Form(
                              key: inputControllers.formKey,
                              child: TextFormField(
                                style: GoogleFonts.urbanist(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .tertiary
                                      .withOpacity(0.7),
                                  fontSize: width * 0.035,
                                ),
                                maxLines: 5,
                                validator: (value) {
                                  if (value == null) {
                                    return "Please Enter a Description";
                                  }
                                  return null;
                                },
                                controller:
                                    inputControllers.descriptionController,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                  filled: true,
                                  fillColor: Theme.of(
                                    context,
                                  ).colorScheme.surface.withOpacity(0.3),
                                  hintText: 'Share your thoughts...',
                                  hintStyle: GoogleFonts.urbanist(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.tertiary.withOpacity(0.5),
                                  ),
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
                                    }
                                  },
                                  text: 'Post'
                                      ' ${inputControllers.loading ? '' : 'Now'}',
                                  textStyle: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .surface),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
