import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class InterfaceController extends ChangeNotifier {
  //
  String aboutApplicaiton =
      "ShopEase is a full-featured e-commerce mobile application built with Flutter that delivers a seamless shopping experience. The app provides users with a comprehensive platform to browse products, manage their shopping cart, and complete purchases with ease. Our integrated AI-powered chatbot assistant helps users with product recommendations, answers questions, and provides support throughout their shopping journey while maintaining a conversation history for continuity.";
  //  List of images for carousel view on interface page
  final List<String> _carouselItems = [
    "assets/Carousel/carousel1.jpg",
    "assets/Carousel/carousel2.jpg",
    "assets/Carousel/carousel3.jpg",
    "assets/Carousel/carousel4.jpg",
    "assets/Carousel/carousel5.jpg",
    "assets/Carousel/carousel6.jpg",
    "assets/Carousel/carousel7.jpg",
    "assets/Carousel/carousel8.jpg",
    "assets/Carousel/carousel9.jpg",
  ];

  //  List of images for large category tiles on interface page
  final List<String> _largeCategoryItems = [
    "assets/categories/Clothing.jpeg",
    "assets/categories/Cosmetics.jpeg",
    "assets/categories/Female Footwear.jpeg",
    "assets/categories/Male Footwear.jpeg",
    "assets/categories/Female Accessories.jpeg",
    "assets/categories/Male Accessories.jpeg",
    "assets/categories/Men Clothing.jpeg",
    "assets/categories/Women Clothing.jpeg",
    "assets/categories/Furniture.jpeg",
    "assets/categories/Smoke.jpeg",
  ];

  //  List of titles for large category tiles on interface page
  final List<String> _largeCategoryTitles = [
    "Clothing",
    "Cosmetics",
    "Female Footwear",
    "Male Footwear",
    "Female Gear",
    "Male Gear",
    "Men Wear",
    "Women Wear",
    "Furniture",
    "Smoke",
  ];

  //  Instance for Firebase Firestore
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  //  Getters
  FirebaseFirestore get fireStore => _fireStore;
  List<String> get largeCategoryTitles => _largeCategoryTitles;
  List<String> get largeCategoryItems => _largeCategoryItems;
  List<String> get carouselItems => _carouselItems;
}
