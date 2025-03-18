import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_swap/utils/flutter_toast.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FeedServices extends ChangeNotifier {
  //  Instacnce for firebase firestore
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  //  Instance for supabase database
  final SupabaseClient _supabase = Supabase.instance.client;

  //  variables
  File? _image;
  final picker = ImagePicker();

  //  getters
  FirebaseFirestore get fireStore => _fireStore;
  SupabaseClient get supabase => _supabase;
  File? get image => _image;
  bool loading = false;

  //  Method to pick the image from the gallery
  Future<void> pickImageFromGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      _image = File(pickedFile.path);
    }
    notifyListeners();
  }

  //  Method to upload the data to the database
  Future<void> uploadDataToDatabase(
    TextEditingController descriptionController,
    BuildContext context,
  ) async {
    //  Check if the image is selected or not
    if (_image == null) {
      FlutterToast().toastMessage("Please Select an Image");
      notifyListeners();
      return;
    }

    //  Check if the description controller is empty
    if (descriptionController.text.isEmpty) {
      FlutterToast().toastMessage("Please Write a description");
      notifyListeners();
      return;
    }

    String postId = DateTime.now().microsecondsSinceEpoch.toString();
    String fileName = "post_$postId.jpg";

    //  Read the image as bytes and store into the bucket
    try {
      loading = true;
      notifyListeners();

      final bytes = await _image!.readAsBytes();

      //  image went to storage
      await supabase.storage.from("feed").updateBinary(fileName, bytes);

      final imageUrl = supabase.storage.from("feed").getPublicUrl(fileName);

      //  Post the data to firestore database
      await fireStore
          .collection("Feed")
          .doc(postId)
          .set({
            'image': imageUrl,
            'description': descriptionController.text,
            'postId': postId,
            'timeStamp': DateTime.timestamp(),
          })
          .then((value) {
            log("Post Uploaded");
          })
          .onError((error, stacktrace) {
            log(error.toString());
          });
    } catch (error) {
      log(error.toString());
    }
  }
}
