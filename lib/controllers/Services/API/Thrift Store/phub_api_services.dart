import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:Konexea/Model/product_model.dart';

class PHubApiServices extends ChangeNotifier {
  //  Loading Variable
  bool isLoading = false;
  //  EndPoint for Thrift Store
  final String endPoint = "https://fakestoreapi.com/products";

  //  List for storing data from the API
  List<Product> productData = [];

  //  Method to fetch data from the API
  Future<List<Product>> fetchData() async {
    try {
      final response = await http.get(Uri.parse(endPoint));
      if (response.statusCode == 200) {
        log("Data fetched successfully");
        List<dynamic> data = jsonDecode(response.body);
        productData = data.map((e) => Product.fromJson(e)).toList();
        log(productData.length.toString());
        notifyListeners();
        return productData;
      } else {
        log("Failed to load data");
        return [];
      }
    } catch (error) {
      log(error.toString());
      return [];
    }
  }
}
