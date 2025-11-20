import 'package:flutter/material.dart';
import 'package:siren_app/features/blog/presentation/pages/news_page.dart';
import 'package:url_launcher/url_launcher.dart';


class NewsDetailsPage extends StatelessWidget {
  final NewsArticle article;

  const NewsDetailsPage({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(article.source ?? "News")),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // -----------------------------
            // TITLE
            // -----------------------------
            Text(
              article.title,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            // -----------------------------
            // PUBLISHED DATE
            // -----------------------------
            if (article.publishedAt != null)
              Text(
                "Published: ${article.publishedAt!.toLocal().toString().split('.').first}",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),

            const SizedBox(height: 16),

            // -----------------------------
            // DESCRIPTION
            // -----------------------------
            if (article.description != null)
              Text(
                article.description!,
                style: const TextStyle(fontSize: 17, height: 1.4),
              ),

            const SizedBox(height: 24),

            // -----------------------------
            // OPEN IN BROWSER BUTTON
            // -----------------------------
            if (article.url != null)
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    final uri = Uri.parse(article.url!);
                    if (await canLaunchUrl(uri)) {
                      await launchUrl(uri, mode: LaunchMode.externalApplication);
                    }
                  },
                  child: const Text("Read Full Article"),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
