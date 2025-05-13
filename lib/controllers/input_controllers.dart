import 'package:flutter/widgets.dart';
import 'package:Konexea/Model/product_model.dart';

class InputControllers {
  //  Loading variable
  bool loading = false;
  //  Form Validator
  final formKey = GlobalKey<FormState>();
  final List<Product> cartItems = [];
  String sortOption = 'Default';
  //  Text Field Controllers
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController messageController = TextEditingController();
  final TextEditingController searchController = TextEditingController();

  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    descriptionController.dispose();
    messageController.dispose();
    searchController.dispose();
  }
}
