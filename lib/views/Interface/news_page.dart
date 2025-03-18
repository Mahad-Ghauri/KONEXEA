import 'package:flutter/material.dart';
import 'package:social_swap/controllers/api_services.dart';
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
  String _sortBy = "publishedAt";
  final List<String> _sortOptions = ["publishedAt", "relevancy", "popularity"];

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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'News',
          style: GoogleFonts.urbanist(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onPressed: () => _showFilterDialog(),
          ),
        ],
      ),
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
                fillColor: Colors.grey[200],
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
                  return const Center(child: CircularProgressIndicator());
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
                          ? buildFeaturedNewsCard(article)
                          : buildStandardNewsCard(article);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _performSearch() {
    setState(() {
      _searchQuery =
          _searchController.text.trim().isEmpty
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

  Future<void> _showFilterDialog() async {
    String? tempFromDate = _fromDate;
    String? tempToDate = _toDate;
    String tempSortBy = _sortBy;

    await showDialog(
      context: context,
      builder:
          (context) => StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                title: Text('Filter News', style: GoogleFonts.urbanist()),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      title: Text('From Date', style: GoogleFonts.urbanist()),
                      subtitle: Text(
                        tempFromDate ?? "Not set",
                        style: GoogleFonts.urbanist(),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.calendar_today),
                        onPressed: () async {
                          final date = await showDatePicker(
                            context: context,
                            initialDate:
                                tempFromDate != null
                                    ? DateFormat(
                                      'yyyy-MM-dd',
                                    ).parse(tempFromDate!)
                                    : DateTime.now().subtract(
                                      const Duration(days: 7),
                                    ),
                            firstDate: DateTime.now().subtract(
                              const Duration(days: 30),
                            ),
                            lastDate: DateTime.now(),
                          );
                          if (date != null) {
                            setState(() {
                              tempFromDate = DateFormat(
                                'yyyy-MM-dd',
                              ).format(date);
                            });
                          }
                        },
                      ),
                    ),
                    ListTile(
                      title: Text('To Date', style: GoogleFonts.urbanist()),
                      subtitle: Text(
                        tempToDate ?? "Not set",
                        style: GoogleFonts.urbanist(),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.calendar_today),
                        onPressed: () async {
                          final date = await showDatePicker(
                            context: context,
                            initialDate:
                                tempToDate != null
                                    ? DateFormat(
                                      'yyyy-MM-dd',
                                    ).parse(tempToDate!)
                                    : DateTime.now(),
                            firstDate:
                                tempFromDate != null
                                    ? DateFormat(
                                      'yyyy-MM-dd',
                                    ).parse(tempFromDate!)
                                    : DateTime.now().subtract(
                                      const Duration(days: 30),
                                    ),
                            lastDate: DateTime.now(),
                          );
                          if (date != null) {
                            setState(() {
                              tempToDate = DateFormat(
                                'yyyy-MM-dd',
                              ).format(date);
                            });
                          }
                        },
                      ),
                    ),
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: "Sort By",
                        labelStyle: GoogleFonts.urbanist(),
                      ),
                      value: tempSortBy,
                      items:
                          _sortOptions
                              .map(
                                (option) => DropdownMenuItem(
                                  value: option,
                                  child: Text(
                                    option,
                                    style: GoogleFonts.urbanist(),
                                  ),
                                ),
                              )
                              .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            tempSortBy = value;
                          });
                        }
                      },
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text('Cancel', style: GoogleFonts.urbanist()),
                  ),
                  TextButton(
                    onPressed: () {
                      this.setState(() {
                        _fromDate = tempFromDate;
                        _toDate = tempToDate;
                        _sortBy = tempSortBy;
                      });
                      Navigator.of(context).pop();
                      _fetchNewsWithCurrentFilters();
                    },
                    child: Text('Apply', style: GoogleFonts.urbanist()),
                  ),
                ],
              );
            },
          ),
    );
  }

  PageRouteBuilder _elegantRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var fadeAnimation = Tween<double>(begin: 0, end: 1).animate(animation);
        var scaleAnimation = Tween<double>(begin: 0.95, end: 1).animate(
          CurvedAnimation(parent: animation, curve: Curves.easeOutExpo),
        );
        return FadeTransition(
          opacity: fadeAnimation,
          child: ScaleTransition(scale: scaleAnimation, child: child),
        );
      },
      transitionDuration: const Duration(milliseconds: 500),
    );
  }
}
