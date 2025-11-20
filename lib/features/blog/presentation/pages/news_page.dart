import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:siren_app/features/blog/presentation/pages/news_detail_page.dart';

// -------------------------------------------------------------
// MODEL: News Article
// -------------------------------------------------------------
class NewsArticle {
  final String title;
  final String? description;
  final String? url;
  final String? source;
  final DateTime? publishedAt;

  NewsArticle({
    required this.title,
    this.description,
    this.url,
    this.source,
    this.publishedAt,
  });
}

// -------------------------------------------------------------
// PAGE: News Page
// -------------------------------------------------------------
class NewsPage extends StatefulWidget {
  const NewsPage({super.key});

  static route() => MaterialPageRoute(builder: (context) => const NewsPage());

  @override
  State<NewsPage> createState() => _NewsPageState();
}

// -------------------------------------------------------------
// STATE: News Page State
// -------------------------------------------------------------
class _NewsPageState extends State<NewsPage> {
  late Future<List<NewsArticle>> _futureNews;

  @override
  void initState() {
    super.initState();
    _futureNews = _fetchMonroeNews();
  }

  // -------------------------------------------------------------
  // API Fetch: Monroe News
  // -------------------------------------------------------------
  Future<List<NewsArticle>> _fetchMonroeNews() async {
    final uri = Uri.parse(
      'https://newsapi.org/v2/everything'
      '?q=Monroe'
      '&language=en'
      '&sortBy=publishedAt'
      '&pageSize=20'
      '&apiKey=b6f77122b6f44fd899b8cbf793759d54',
    );

    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception('Failed to load local news');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final articles = data['articles'] as List<dynamic>;

    return articles.map((raw) {
      final map = raw as Map<String, dynamic>;

      return NewsArticle(
        title: map['title'] ?? 'No title',
        description: map['description'],
        url: map['url'],
        source: (map['source'] as Map<String, dynamic>?)?['name'],
        publishedAt: map['publishedAt'] != null
            ? DateTime.tryParse(map['publishedAt'])
            : null,
      );
    }).toList();
  }

  // -------------------------------------------------------------
  // UI BUILD
  // -------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Monroe Local News')),

      body: FutureBuilder<List<NewsArticle>>(
        future: _futureNews,
        builder: (context, snapshot) {
          // Loading State
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // Error State
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Could not load local news.\n\n${snapshot.error}',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          final news = snapshot.data ?? [];

          // Empty State
          if (news.isEmpty) {
            return const Center(
              child: Text(
                'No recent news found for Monroe.\nTry again later.',
                textAlign: TextAlign.center,
              ),
            );
          }

          // News List
          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: news.length,
            itemBuilder: (context, index) {
              final article = news[index];

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 6),
                child: ListTile(
                  title: Text(
                    article.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (article.description != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Text(
                            article.description!,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),

                      const SizedBox(height: 4),

                      Text(
                        '${article.source ?? 'Unknown source'}'
                        '${article.publishedAt != null ? ' • ${article.publishedAt!.toLocal().toString().split(".").first}' : ''}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),

                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => NewsDetailsPage(article: article),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
