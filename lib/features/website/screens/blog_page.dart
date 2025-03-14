import 'package:flutter/material.dart';
import '../widgets/website_navbar.dart';
import '../widgets/website_footer.dart';

class BlogPage extends StatelessWidget {
  const BlogPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: WebsiteNavbar(currentPage: 'blog'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeroSection(),
            _buildFeaturedArticle(),
            _buildArticlesList(context),
            const WebsiteFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroSection() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 64, vertical: 60),
      color: const Color(0xFFE8F5E9),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'PhysioFlow Blog',
            style: TextStyle(
              fontSize: 42,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1B5E20),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Latest insights on physical therapy innovation, AI in healthcare, and clinical best practices',
            style: TextStyle(
              fontSize: 18,
              color: Color(0xFF424242),
            ),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Search articles...',
                border: InputBorder.none,
                icon: Icon(Icons.search, color: Color(0xFF2E7D32)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturedArticle() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 64, vertical: 60),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'FEATURED ARTICLE',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2E7D32),
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    'assets/images/blog/featured_article.jpg',
                    fit: BoxFit.cover,
                    height: 300,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 300,
                      color: const Color(0xFFE8F5E9),
                      child: const Center(
                        child: Icon(Icons.image,
                            size: 64, color: Color(0xFF2E7D32)),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 40),
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'The Future of Physical Therapy: How AI is Transforming Patient Care',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1B5E20),
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Dr. Emily Chen • March 10, 2025',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF757575),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Discover how artificial intelligence is revolutionizing physical therapy practices, improving form correction, and personalizing treatment plans to accelerate patient recovery.',
                      style: TextStyle(
                        fontSize: 16,
                        height: 1.6,
                        color: Color(0xFF424242),
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2E7D32),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                      ),
                      child: const Text('Read Article'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildArticlesList(BuildContext context) {
    final articles = [
      {
        'title': '5 Exercises to Improve Shoulder Mobility After Injury',
        'author': 'Dr. Michael Rodriguez',
        'date': 'March 5, 2025',
        'category': 'Exercise Prescription',
        'imageUrl': 'assets/images/blog/shoulder.jpg',
      },
      {
        'title': 'How Machine Learning Models Detect Exercise Form Errors',
        'author': 'Sarah Johnson, AI Research Lead',
        'date': 'February 28, 2025',
        'category': 'Technology',
        'imageUrl': 'assets/images/blog/ai_tech.jpg',
      },
      {
        'title': 'Telehealth Physical Therapy: Best Practices for Remote Care',
        'author': 'Amanda Wilson, PT',
        'date': 'February 22, 2025',
        'category': 'Clinical Practice',
        'imageUrl': 'assets/images/blog/telehealth.jpg',
      },
      {
        'title': 'Improving Patient Adherence with Digital Exercise Programs',
        'author': 'Dr. James Park',
        'date': 'February 15, 2025',
        'category': 'Patient Engagement',
        'imageUrl': 'assets/images/blog/adherence.jpg',
      },
      {
        'title': 'The Role of Data Analytics in Modern Physical Therapy',
        'author': 'Lisa Chen, Data Scientist',
        'date': 'February 8, 2025',
        'category': 'Analytics',
        'imageUrl': 'assets/images/blog/analytics.jpg',
      },
    ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 64, vertical: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Latest Articles',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1B5E20),
                ),
              ),
              TextButton(
                onPressed: () {},
                child: const Text(
                  'View All Articles',
                  style: TextStyle(
                    color: Color(0xFF2E7D32),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 24,
              mainAxisSpacing: 24,
              childAspectRatio: 0.85,
            ),
            itemCount: articles.length,
            itemBuilder: (context, index) {
              final article = articles[index];
              return _buildArticleCard(
                title: article['title']!,
                author: article['author']!,
                date: article['date']!,
                category: article['category']!,
                imageUrl: article['imageUrl']!,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildArticleCard({
    required String title,
    required String author,
    required String date,
    required String category,
    required String imageUrl,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Image.asset(
              imageUrl,
              height: 180,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                height: 180,
                color: const Color(0xFFE8F5E9),
                child: const Center(
                  child: Icon(Icons.image, size: 48, color: Color(0xFF2E7D32)),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F5E9),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    category,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF2E7D32),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1B5E20),
                    height: 1.3,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Text(
                  '$author • $date',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF757575),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
