// ignore_for_file: use_build_context_synchronously, deprecated_member_use, prefer_final_fields

import 'package:Konexea/Views/Components/News/news_card.dart';
import 'package:flutter/material.dart';
import 'package:Konexea/controllers/Services/API/News API/api_services.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';


class NewsPage extends StatefulWidget {
  const NewsPage({super.key});

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "tesla";
  String? _fromDate;
  String? _toDate;
  final String _sortBy = "publishedAt";

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    final defaultFromDate = now.subtract(const Duration(days: 7));
    _fromDate = DateFormat('yyyy-MM-dd').format(defaultFromDate);

    Future.microtask(() {
      Provider.of<ApiServices>(
        context,
        listen: false,
      ).fetchNews(query: _searchQuery, fromDate: _fromDate, sortBy: _sortBy);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Stack(
      children: [
        Positioned.fill(
          child: Container(color: Theme.of(context).colorScheme.surface),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.surface,
            // leading: Icon(
            //   FontAwesomeIcons.infinity,
            //   color: Theme.of(context).colorScheme.primary,
            // ),
            title: const Text('News Page'),
            titleTextStyle: TextStyle(
              color: Theme.of(context).colorScheme.tertiary,
              fontSize: height * 0.024,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
              fontFamily: GoogleFonts.lobsterTwo().fontFamily,
            ),
          ),
          body: Column(
            children: [
              Expanded(
                child: Consumer<ApiServices>(
                  builder: (context, apiService, _) {
                    if (apiService.isLoading) {
                      return Center(
                        child: CircularProgressIndicator(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      );
                    }

                    if (apiService.errorMessage != null) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              apiService.errorMessage!,
                              style: GoogleFonts.urbanist(color: Colors.red),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: _refreshNews,
                              child: Text(
                                'Try Again',
                                style: GoogleFonts.urbanist(),
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    if (apiService.newsList.isEmpty) {
                      return Center(
                        child: Text(
                          'No news available',
                          style: GoogleFonts.urbanist(),
                        ),
                      );
                    }

                    final news = apiService.newsList.first;
                    final articles = news.articles;

                    if (articles.isEmpty) {
                      return Center(
                        child: Text(
                          'No articles found for this search',
                          style: GoogleFonts.urbanist(),
                        ),
                      );
                    }

                    return RefreshIndicator(
                      onRefresh: () async => _refreshNews(),
                      child: ListView.builder(
                        padding: const EdgeInsets.only(top: 4),
                        itemCount: articles.length,
                        itemBuilder: (context, index) {
                          final article = articles[index];
                          return index == 0
                              ? _buildFeaturedNewsCard(article)
                              : _buildStandardNewsCard(article, context);
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFeaturedNewsCard(dynamic article) {
    return buildFeaturedNewsCard(article);
  }

  Widget _buildStandardNewsCard(dynamic article, BuildContext context) {
    return buildStandardNewsCard(context, article);
  }

  void _refreshNews() {
    Provider.of<ApiServices>(context, listen: false).refreshNews(
      query: _searchQuery,
      fromDate: _fromDate,
      toDate: _toDate,
      sortBy: _sortBy,
    );
  }
}
