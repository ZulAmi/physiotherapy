import 'package:flutter/material.dart';
import '../widgets/website_navbar.dart';
import '../widgets/website_footer.dart';

class KnowledgeBasePage extends StatefulWidget {
  const KnowledgeBasePage({super.key});

  @override
  State<KnowledgeBasePage> createState() => _KnowledgeBasePageState();
}

class _KnowledgeBasePageState extends State<KnowledgeBasePage> {
  String _selectedCategory = 'All';
  final List<String> _categories = [
    'All',
    'Getting Started',
    'Account Management',
    'Patient Records',
    'Exercise Monitoring',
    'Billing',
    'Technical Support'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: WebsiteNavbar(currentPage: 'knowledge-base'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeroSection(),
            _buildCategories(),
            _buildFAQSection(),
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
        children: [
          const Text(
            'Knowledge Base',
            style: TextStyle(
              fontSize: 42,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1B5E20),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Find answers to common questions and learn how to get the most out of PhysioFlow',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              color: Color(0xFF424242),
            ),
          ),
          const SizedBox(height: 32),
          Container(
            width: 600,
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
            child: const TextField(
              decoration: InputDecoration(
                hintText: 'Search for answers...',
                border: InputBorder.none,
                icon: Icon(Icons.search, color: Color(0xFF2E7D32)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategories() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 64, vertical: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Browse By Category',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1B5E20),
            ),
          ),
          const SizedBox(height: 24),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: _categories.map((category) {
              final isSelected = category == _selectedCategory;
              return ChoiceChip(
                label: Text(category),
                selected: isSelected,
                onSelected: (selected) {
                  if (selected) {
                    setState(() {
                      _selectedCategory = category;
                    });
                  }
                },
                backgroundColor: Colors.white,
                selectedColor: const Color(0xFFE8F5E9),
                labelStyle: TextStyle(
                  color: isSelected ? const Color(0xFF2E7D32) : Colors.black87,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildFAQSection() {
    final faqs = [
      {
        'category': 'Getting Started',
        'question': 'How do I set up my clinic profile?',
        'answer':
            'To set up your clinic profile, log in as an administrator and navigate to Settings > Clinic Profile. From there, you can add your clinic logo, address, contact information, and customize your patient portal appearance.'
      },
      {
        'category': 'Exercise Monitoring',
        'question': 'What devices support AI exercise monitoring?',
        'answer':
            "PhysioFlow's AI exercise monitoring works on most iOS and Android devices with a camera. For optimal performance, we recommend devices manufactured after 2020 with at least 4GB of RAM. The feature works with both front and rear cameras."
      },
      {
        'category': 'Account Management',
        'question': 'How do I add a new therapist to my practice?',
        'answer':
            "To add a new therapist, go to Settings > Team Management > Add New Therapist. Enter their email address and they'll receive an invitation to join your practice. Once they accept, you can assign roles and permissions."
      },
      {
        'category': 'Patient Records',
        'question': 'Can patients access their own exercise history?',
        'answer':
            "Yes, patients can access their exercise history through the patient portal or mobile app. They'll be able to see their prescribed exercises, completion rates, progress over time, and any feedback from their therapist."
      },
      {
        'category': 'Billing',
        'question': 'How do I update my subscription plan?',
        'answer':
            'To update your subscription, go to Settings > Billing > Manage Subscription. You can upgrade, downgrade, or change your billing cycle. Changes to your subscription will take effect at the start of your next billing period.'
      },
      {
        'category': 'Exercise Monitoring',
        'question': 'How accurate is the AI form monitoring?',
        'answer':
            'Our AI form monitoring has been validated with over 10,000 hours of exercise data and achieves 95%+ accuracy for the supported exercises. The system continuously improves through machine learning as more data is collected.'
      },
      {
        'category': 'Technical Support',
        'question': 'What should I do if the app crashes?',
        'answer':
            'If the app crashes, try restarting the application. If the issue persists, check your internet connection and update to the latest version. You can report crashes by going to Help > Report an Issue, which will send our team the diagnostic information needed to address the problem.'
      },
    ];

    // Filter FAQs by selected category
    final filteredFaqs = _selectedCategory == 'All'
        ? faqs
        : faqs.where((faq) => faq['category'] == _selectedCategory).toList();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 64, vertical: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _selectedCategory == 'All'
                ? 'Frequently Asked Questions'
                : '$_selectedCategory FAQs',
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1B5E20),
            ),
          ),
          const SizedBox(height: 24),
          ...filteredFaqs.map((faq) => _buildFAQItem(
                category: faq['category']!,
                question: faq['question']!,
                answer: faq['answer']!,
              )),
          if (filteredFaqs.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(40),
                child: Column(
                  children: [
                    const Icon(
                      Icons.search_off,
                      size: 64,
                      color: Color(0xFFAED581),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No FAQs found for $_selectedCategory',
                      style: const TextStyle(
                        fontSize: 18,
                        color: Color(0xFF424242),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Try selecting a different category or search for your question above',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF757575),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          const SizedBox(height: 40),
          Center(
            child: Column(
              children: [
                const Text(
                  'Still have questions?',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1B5E20),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.support_agent),
                  label: const Text('Contact Support'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2E7D32),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 16),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFAQItem({
    required String category,
    required String question,
    required String answer,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ExpansionTile(
        title: Text(
          question,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        subtitle: Text(
          category,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.only(
              left: 16,
              right: 16,
              bottom: 16,
            ),
            child: Align(
              alignment: Alignment.topLeft,
              child: Text(
                answer,
                style: const TextStyle(fontSize: 14, height: 1.5),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
