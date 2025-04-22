// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'package:flutter/material.dart';

import 'package:social_swap/controllers/Services/API/api_services.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:social_swap/views/components/news_card.dart';

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
    return Stack(
      children: [
        Positioned.fill(
          child: Container(color: Theme.of(context).colorScheme.surface),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: "Search news...",
                    hintStyle: GoogleFonts.urbanist(),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.primary,
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        _performSearch();
                      },
                    ),
                  ),
                  onSubmitted: (_) => _performSearch(),
                ),
              ),
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
                              : _buildStandardNewsCard(article);
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

  Widget _buildStandardNewsCard(dynamic article) {
    return buildStandardNewsCard(article);
  }

  void _performSearch() {
    setState(() {
      _searchQuery = _searchController.text.trim().isEmpty
          ? "tesla"
          : _searchController.text.trim();
    });
    _fetchNewsWithCurrentFilters();
  }

  void _refreshNews() {
    Provider.of<ApiServices>(context, listen: false).refreshNews(
      query: _searchQuery,
      fromDate: _fromDate,
      toDate: _toDate,
      sortBy: _sortBy,
    );
  }

  void _fetchNewsWithCurrentFilters() {
    Provider.of<ApiServices>(context, listen: false).fetchNews(
      query: _searchQuery,
      fromDate: _fromDate,
      toDate: _toDate,
      sortBy: _sortBy,
    );
  }
}
