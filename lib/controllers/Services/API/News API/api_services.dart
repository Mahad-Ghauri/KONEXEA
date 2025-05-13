import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:Konexea/Model/news_model.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:google_mlkit_translation/google_mlkit_translation.dart';

class ApiServices extends ChangeNotifier {
  // API configuration
  final String apiKey = "b866cc5d567845a782b3b65b6b055a6e";
  final String baseUrl = "https://newsapi.org/v2";

  // Translation configuration
  // final _onDeviceTranslator = OnDeviceTranslator(
  //   sourceLanguage: TranslateLanguage.spanish,
  //   targetLanguage: TranslateLanguage.english,
  // );

  // Cache configuration
  DateTime? _lastFetchTime;
  Duration cacheDuration = const Duration(minutes: 15);

  // Loading state
  bool isLoading = false;
  String? errorMessage;

  // List to store data from the api
  List<NewsApiResponse> newsList = [];

  // Method to translate text to English
  Future<String> translateToEnglish(String text) async {
    try {
      if (text.isEmpty) return text;
      // Create a new translator instance for each translation to ensure proper language detection
      final translator = OnDeviceTranslator(
        sourceLanguage: TranslateLanguage.spanish,
        targetLanguage: TranslateLanguage.english,
      );
      final translatedText = await translator.translateText(text);
      return translatedText;
    } catch (error) {
      log("Translation error: ${error.toString()}");
      return text; // Return original text if translation fails
    }
  }

  // Method to translate an article
  Future<Article> translateArticle(Article article) async {
    try {
      final translatedTitle = await translateToEnglish(article.title);
      final translatedDescription = await translateToEnglish(
        article.description,
      );
      final translatedContent = await translateToEnglish(article.content);

      return Article(
        source: article.source,
        author: article.author,
        title: translatedTitle,
        description: translatedDescription,
        url: article.url,
        urlToImage: article.urlToImage,
        publishedAt: article.publishedAt,
        content: translatedContent,
      );
    } catch (error) {
      log("Article translation error: ${error.toString()}");
      return article; // Return original article if translation fails
    }
  }

  // Builds the API endpoint with query parameters
  String _buildEndpoint({
    String endpoint = "everything",
    String query = "technology",
    String? fromDate,
    String? toDate,
    String sortBy = "publishedAt",
    int pageSize = 20,
    int page = 1,
  }) {
    // Format dates or use defaults
    final now = DateTime.now();
    final formatter = DateFormat('yyyy-MM-dd');
    final from =
        fromDate ?? formatter.format(now.subtract(const Duration(days: 7)));

    final queryParams = {
      'q': query,
      'from': from,
      'sortBy': sortBy,
      'pageSize': pageSize.toString(),
      'page': page.toString(),
      'apiKey': apiKey,
    };

    // Add optional to date if provided
    if (toDate != null) {
      queryParams['to'] = toDate;
    }

    // Build URL with query parameters
    final Uri uri = Uri.parse(
      '$baseUrl/$endpoint',
    ).replace(queryParameters: queryParams);
    return uri.toString();
  }

  // Method to fetch data from the api
  Future<List<NewsApiResponse>> fetchNews({
    bool forceRefresh = false,
    String query = "technology",
    String? fromDate,
    String? toDate,
    String sortBy = "publishedAt",
  }) async {
    try {
      // Use cached data if available and not forcing refresh
      if (!forceRefresh &&
          _lastFetchTime != null &&
          DateTime.now().difference(_lastFetchTime!) < cacheDuration &&
          newsList.isNotEmpty) {
        log("Using cached news data");
        return newsList;
      }

      // Set loading state
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      // Build the endpoint URL
      final endpoint = _buildEndpoint(
        query: query,
        fromDate: fromDate,
        toDate: toDate,
        sortBy: sortBy,
      );
      log("Fetching news from: $endpoint");

      // Setup headers
      final headers = {
        'Accept': 'application/json',
        'User-Agent': 'Flutter News App/1.0',
      };

      // Make the request
      final response = await http
          .get(Uri.parse(endpoint), headers: headers)
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        log("Data fetched successfully");

        // Parse JSON response
        Map<String, dynamic> jsonData = jsonDecode(response.body);

        // Check if response contains the expected data structure
        if (jsonData.containsKey('articles')) {
          NewsApiResponse newsResponse = NewsApiResponse.fromJson(jsonData);

          // Translate all articles
          List<Article> translatedArticles = [];
          for (var article in newsResponse.articles) {
            final translatedArticle = await translateArticle(article);
            translatedArticles.add(translatedArticle);
          }

          // Create new NewsApiResponse with translated articles
          newsResponse = NewsApiResponse(
            status: newsResponse.status,
            totalResults: newsResponse.totalResults,
            articles: translatedArticles,
          );

          // Update the cache and data
          newsList.clear();
          newsList.add(newsResponse);
          _lastFetchTime = DateTime.now();

          log(
            "Fetched and translated ${newsResponse.articles.length} news articles",
          );

          isLoading = false;
          notifyListeners();
          return newsList;
        } else {
          log("Invalid response format: ${response.body}");
          errorMessage = "Invalid response format from server";
          isLoading = false;
          notifyListeners();
          return [];
        }
      } else if (response.statusCode == 401) {
        log("Error 401 - Unauthorized: ${response.body}");
        errorMessage =
            "Invalid API key. Please check your API key and try again.";
        isLoading = false;
        notifyListeners();
        return [];
      } else if (response.statusCode == 429) {
        log("Error 429 - Too Many Requests: ${response.body}");
        errorMessage = "You've made too many requests. Please try again later.";
        isLoading = false;
        notifyListeners();
        return [];
      } else {
        log(
          "Failed to fetch data. Status code: ${response.statusCode}. Response: ${response.body}",
        );
        errorMessage = "Failed to load news (Error ${response.statusCode})";
        isLoading = false;
        notifyListeners();
        return [];
      }
    } on SocketException catch (e) {
      log("Network error: ${e.toString()}");
      errorMessage = "Check your internet connection";
      isLoading = false;
      notifyListeners();
      return [];
    } on TimeoutException catch (error) {
      log("Request timed out: ${error.toString()}");
      errorMessage = "Request timed out. Try again later";
      isLoading = false;
      notifyListeners();
      return [];
    } catch (error) {
      log("Error fetching news: ${error.toString()}");
      errorMessage = "An unexpected error occurred";
      isLoading = false;
      notifyListeners();
      return [];
    }
  }

  // Clear cache and force refresh
  void refreshNews({
    String query = "technology",
    String? fromDate,
    String? toDate,
    String sortBy = "publishedAt",
  }) {
    _lastFetchTime = null;
    fetchNews(
      forceRefresh: true,
      query: query,
      fromDate: fromDate,
      toDate: toDate,
      sortBy: sortBy,
    );
  }
}
