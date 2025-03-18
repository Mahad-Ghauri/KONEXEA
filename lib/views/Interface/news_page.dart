import 'package:flutter/material.dart';
import 'package:social_swap/controllers/api_services.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

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
    // Set default from date to 7 days ago
    final now = DateTime.now();
    final defaultFromDate = now.subtract(const Duration(days: 7));
    _fromDate = DateFormat('yyyy-MM-dd').format(defaultFromDate);

    // Initial data load
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
        title: const Text('News App'),
        backgroundColor: Colors.blueGrey,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => _refreshNews(),
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showFilterDialog(),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Search news...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () => _performSearch(),
                ),
              ),
              onSubmitted: (_) => _performSearch(),
            ),
          ),

          // Active filters display
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                const Text(
                  "Filters: ",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text("From: ${_fromDate ?? 'Any'} "),
                if (_toDate != null) Text("To: $_toDate "),
                Text("Sort: $_sortBy"),
              ],
            ),
          ),

          // News content
          Expanded(
            child: Consumer<ApiServices>(
              builder: (context, apiService, _) {
                // Loading state
                if (apiService.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                // Error state
                if (apiService.errorMessage != null) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            apiService.errorMessage!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.red),
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () => _refreshNews(),
                            child: const Text("Try Again"),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                // Empty state
                if (apiService.newsList.isEmpty) {
                  return const Center(child: Text("No news available"));
                }

                // Get the news data
                final news = apiService.newsList.first;
                final articles = news.articles;

                // No articles found
                if (articles.isEmpty) {
                  return const Center(
                    child: Text("No articles found for this search"),
                  );
                }

                // Display articles
                return RefreshIndicator(
                  onRefresh: () async => _refreshNews(),
                  child: ListView.builder(
                    padding: const EdgeInsets.all(8.0),
                    itemCount: articles.length,
                    itemBuilder: (context, index) {
                      final article = articles[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 8.0,
                          vertical: 8.0,
                        ),
                        elevation: 3,
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Image
                              if (article.image.isNotEmpty)
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: Image.network(
                                    article.image,
                                    height: 180,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, _, __) {
                                      return Container(
                                        height: 180,
                                        color: Colors.grey[300],
                                        child: const Center(
                                          child: Icon(Icons.error_outline),
                                        ),
                                      );
                                    },
                                  ),
                                ),

                              // Title
                              const SizedBox(height: 12),
                              Text(
                                article.title,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),

                              // Author
                              if (article.author != null)
                                Padding(
                                  padding: const EdgeInsets.only(top: 4.0),
                                  child: Text(
                                    "By: ${article.author}",
                                    style: const TextStyle(
                                      fontStyle: FontStyle.italic,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),

                              // Description
                              const SizedBox(height: 8),
                              Text(
                                article.description,
                                style: const TextStyle(fontSize: 14),
                              ),

                              // Source and date
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Source: ${article.source.name}",
                                    style: const TextStyle(color: Colors.grey),
                                  ),
                                  Text(
                                    _formatDate(article.publishDate),
                                    style: const TextStyle(
                                      fontStyle: FontStyle.italic,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
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
                title: const Text("Filter News"),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // From Date Picker
                    ListTile(
                      title: const Text("From Date"),
                      subtitle: Text(tempFromDate ?? "Not set"),
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

                    // To Date Picker
                    ListTile(
                      title: const Text("To Date"),
                      subtitle: Text(tempToDate ?? "Not set"),
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

                    // Sort By Dropdown
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(labelText: "Sort By"),
                      value: tempSortBy,
                      items:
                          _sortOptions
                              .map(
                                (option) => DropdownMenuItem(
                                  value: option,
                                  child: Text(option),
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
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text("Cancel"),
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
                    child: const Text("Apply"),
                  ),
                ],
              );
            },
          ),
    );
  }

  String _formatDate(DateTime date) {
    return DateFormat('MMM d, yyyy').format(date);
  }
}
