import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class UploadPage extends StatefulWidget {
  const UploadPage({super.key});

  @override
  State<UploadPage> createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _captionController = TextEditingController();
  bool _isImageSelected = false;

  @override
  void dispose() {
    _captionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Create Post',
          style: GoogleFonts.italiana(
            color: Theme.of(context).colorScheme.primary,
            fontSize: height * 0.03,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                // Handle post creation
              }
            },
            child: Text(
              'Post',
              style: GoogleFonts.urbanist(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(width * 0.05),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _captionController,
                  maxLines: 5,
                  decoration: InputDecoration(
                    hintText: 'What\'s on your mind?',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.surface,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                ),
                SizedBox(height: height * 0.02),
                GestureDetector(
                  onTap: () {
                    // Handle image selection
                    setState(() {
                      _isImageSelected = true;
                    });
                  },
                  child: Container(
                    height: height * 0.3,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.tertiary,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child:
                        _isImageSelected
                            ? const Center(child: Icon(Icons.image))
                            : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.add_photo_alternate_outlined,
                                  size: height * 0.05,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                SizedBox(height: height * 0.01),
                                Text(
                                  'Add Photo',
                                  style: GoogleFonts.urbanist(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    fontSize: height * 0.018,
                                  ),
                                ),
                              ],
                            ),
                  ),
                ),
                SizedBox(height: height * 0.02),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildOptionButton(
                      context,
                      Icons.videocam_outlined,
                      'Video',
                      height,
                    ),
                    _buildOptionButton(
                      context,
                      Icons.location_on_outlined,
                      'Location',
                      height,
                    ),
                    _buildOptionButton(
                      context,
                      Icons.emoji_emotions_outlined,
                      'Feeling',
                      height,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOptionButton(
    BuildContext context,
    IconData icon,
    String label,
    double height,
  ) {
    return TextButton.icon(
      onPressed: () {},
      icon: Icon(icon, color: Theme.of(context).colorScheme.primary),
      label: Text(
        label,
        style: GoogleFonts.urbanist(
          color: Theme.of(context).colorScheme.primary,
          fontSize: height * 0.016,
        ),
      ),
    );
  }
}
