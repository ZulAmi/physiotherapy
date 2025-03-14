import 'package:flutter/material.dart';
import '../widgets/website_navbar.dart';
import '../widgets/website_footer.dart';

class CaseStudiesPage extends StatefulWidget {
  const CaseStudiesPage({super.key});

  @override
  State<CaseStudiesPage> createState() => _CaseStudiesPageState();
}

class _CaseStudiesPageState extends State<CaseStudiesPage> {
  String _selectedCategory = 'All';
  final List<String> _categories = [
    'All',
    'Orthopedic',
    'Neurological',
    'Sports Medicine',
    'Pediatric',
    'Enterprise',
  ];

  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: WebsiteNavbar(currentPage: 'case-studies'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeroSection(),
            _buildSearchBar(), // Add this new section
            _buildCategories(),
            _buildCaseStudies(),
            _buildClientTestimonial(),
            _buildCallToAction(), // Add this new section
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
            'Case Studies',
            style: TextStyle(
              fontSize: 42,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1B5E20),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Real world success stories from clinics and practices using PhysioFlow',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              color: Color(0xFF424242),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 64, vertical: 20),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search case studies...',
          prefixIcon: const Icon(Icons.search, color: Color(0xFF2E7D32)),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear, color: Color(0xFF2E7D32)),
                  onPressed: () {
                    _searchController.clear();
                    setState(() {
                      _searchQuery = '';
                    });
                  },
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(color: Color(0xFF2E7D32), width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 16),
          filled: true,
          fillColor: Colors.white,
        ),
        onChanged: (value) {
          setState(() {
            _searchQuery = value.trim();
          });
        },
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
            'Filter by Category',
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

  Widget _buildCaseStudies() {
    // List of case studies
    final caseStudies = [
      {
        'title': 'Mountain View Physical Therapy',
        'category': 'Orthopedic',
        'challenge':
            'High patient dropout rates (37%) during rehabilitation programs with poor home exercise adherence.',
        'solution':
            'Implemented PhysioFlow\'s AI monitoring for at-home exercises with real-time feedback and progress tracking.',
        'results': {
          'Patient adherence': '+68%',
          'Patient satisfaction': '+42%',
          'Average recovery time': '-24%',
          'Clinic revenue': '+18%',
        },
        'quote':
            '"PhysioFlow transformed our practice. Patients love the immediate feedback, and we can finally track what\'s happening outside of clinic visits."',
        'quoteAuthor': 'Dr. Samantha Lee, Clinic Director',
      },
      {
        'title': 'Neuro Rehabilitation Center of Chicago',
        'category': 'Neurological',
        'challenge':
            'Difficulty tracking subtle improvements in stroke patients during home-based movement therapies.',
        'solution':
            'Deployed PhysioFlow\'s precision motion tracking with customized neurological recovery metrics and weekly progress reports.',
        'results': {
          'Movement precision': '+31%',
          'Patient engagement': '+44%',
          'Progress documentation': '+88%',
          'Therapist efficiency': '+27%',
        },
        'quote':
            '"The detailed motion analytics have completely changed how we approach stroke rehabilitation. We can detect improvements that would have been missed before."',
        'quoteAuthor': 'Michael Chen, PT, DPT, Neurological Specialist',
      },
      {
        'title': 'Elite Sports Performance Clinic',
        'category': 'Sports Medicine',
        'challenge':
            'Professional and collegiate athletes requiring precise biomechanical analysis during recovery from injuries.',
        'solution':
            'Implemented PhysioFlow\'s advanced motion analysis with sport-specific exercise libraries and performance benchmarks.',
        'results': {
          'Return-to-play time': '-32%',
          'Re-injury rate': '-41%',
          'Performance metrics': '+22%',
          'Athlete satisfaction': '+85%',
        },
        'quote':
            '"Our athletes can now visualize their progress in real-time. The comparative analysis against their pre-injury benchmarks has been invaluable for building confidence during recovery."',
        'quoteAuthor': 'James Wilson, Head of Sports Rehabilitation',
      },
      {
        'title': 'Children\'s Therapy Associates',
        'category': 'Pediatric',
        'challenge':
            'Keeping younger patients engaged in therapy and exercises between sessions.',
        'solution':
            'Implemented PhysioFlow\'s gamified pediatric exercise platform with AI monitoring and reward systems.',
        'results': {
          'Exercise completion rates': '+74%',
          'Parent satisfaction': '+63%',
          'Average therapy sessions needed': '-18%',
          'Patient engagement scores': '+91%',
        },
        'quote':
            '"The gamification elements have transformed our practice. Kids actually look forward to doing their exercises now, and the progress data helps us optimize treatment plans."',
        'quoteAuthor': 'Dr. Emily Johnson, Pediatric Specialist',
      },
      {
        'title': 'Metropolitan Health System',
        'category': 'Enterprise',
        'challenge':
            'Coordinating physical therapy services across 12 hospitals with inconsistent patient outcomes and tracking.',
        'solution':
            'Enterprise deployment of PhysioFlow with centralized management, standardized protocols, and system-wide analytics.',
        'results': {
          'System-wide consistency': '+47%',
          'Patient outcomes': '+29%',
          'Cost efficiency': '+16%',
          'Insurance reimbursement approval': '+23%',
        },
        'quote':
            '"PhysioFlow has standardized our approach across all locations while still allowing therapists to personalize treatment. The analytics dashboard has become essential for our leadership team."',
        'quoteAuthor': 'Rebecca Torres, VP of Rehabilitation Services',
      },
    ];

    // More robust case study filtering
    final filteredCaseStudies = caseStudies.where((study) {
      // Check if the study matches the selected category
      final matchesCategory =
          _selectedCategory == 'All' || study['category'] == _selectedCategory;

      // Check if the study contains the search query in various fields
      final searchLower = _searchQuery.toLowerCase();
      final matchesSearch = _searchQuery.isEmpty ||
          ((study['title'] as String?)?.toLowerCase().contains(searchLower) ??
              false) ||
          ((study['category'] as String?)
                  ?.toLowerCase()
                  .contains(searchLower) ??
              false) ||
          ((study['challenge'] as String?)
                  ?.toLowerCase()
                  .contains(searchLower) ??
              false) ||
          ((study['solution'] as String?)
                  ?.toLowerCase()
                  .contains(searchLower) ??
              false);

      return matchesCategory && matchesSearch;
    }).toList();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 64, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _selectedCategory == 'All'
                ? 'Featured Case Studies'
                : '$_selectedCategory Case Studies',
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1B5E20),
            ),
          ),
          const SizedBox(height: 32),
          ...filteredCaseStudies
              .map((study) => _buildCaseStudyCard(
                    title: study['title'] as String,
                    category: study['category'] as String,
                    challenge: study['challenge'] as String,
                    solution: study['solution'] as String,
                    results: Map<String, String>.from(
                        study['results'] as Map<dynamic, dynamic>),
                    quote: study['quote'] as String,
                    quoteAuthor: study['quoteAuthor'] as String,
                  ))
              .toList(),
          if (filteredCaseStudies.isEmpty)
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
                      'No case studies found for $_selectedCategory',
                      style: const TextStyle(
                        fontSize: 18,
                        color: Color(0xFF424242),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCaseStudyCard({
    required String title,
    required String category,
    required String challenge,
    required String solution,
    required Map<String, String> results,
    required String quote,
    required String quoteAuthor,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 32),
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
          // Header with title and category
          Container(
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(
              color: Color(0xFF2E7D32),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Text(
                          category,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Show a snackbar for now (in a real app, this would download a PDF)
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Downloading case study for $title...'),
                        duration: const Duration(seconds: 2),
                        action: SnackBarAction(
                          label: 'View',
                          onPressed: () {
                            // This would open the PDF in a real implementation
                          },
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF2E7D32),
                  ),
                  child: const Text('Download PDF'),
                ),
              ],
            ),
          ),
          // Main content
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Challenge & solution section
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Challenge',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1B5E20),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            challenge,
                            style: const TextStyle(
                              fontSize: 15,
                              height: 1.5,
                              color: Color(0xFF424242),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 24),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Solution',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1B5E20),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            solution,
                            style: const TextStyle(
                              fontSize: 15,
                              height: 1.5,
                              color: Color(0xFF424242),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                // Results section
                const Text(
                  'Results',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1B5E20),
                  ),
                ),
                const SizedBox(height: 16),
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 4,
                  crossAxisSpacing: 16,
                  childAspectRatio: 2,
                  children: results.entries.map((entry) {
                    return _buildResultCard(entry.key, entry.value);
                  }).toList(),
                ),
                const SizedBox(height: 32),
                // Quote section
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F5E9),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.format_quote,
                        color: Color(0xFF2E7D32),
                        size: 32,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        quote,
                        style: const TextStyle(
                          fontSize: 16,
                          fontStyle: FontStyle.italic,
                          color: Color(0xFF424242),
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        '- $quoteAuthor',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2E7D32),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultCard(String metric, String value) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: value.contains('+')
                  ? const Color(0xFF2E7D32)
                  : const Color(0xFF1976D2),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            metric,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF616161),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClientTestimonial() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 64),
      color: const Color(0xFFF5F5F5),
      child: Column(
        children: [
          const Text(
            'What Our Clients Say',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1B5E20),
            ),
          ),
          const SizedBox(height: 40),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTestimonialCard(
                name: 'Dr. Robert Freeman',
                title: 'Medical Director, Northwestern Rehabilitation Center',
                image: 'assets/images/testimonials/doctor1.jpg',
                content:
                    'The analytics provided by PhysioFlow have completely transformed how we approach rehabilitation. We can now make data-driven decisions that have measurably improved patient outcomes.',
              ),
              const SizedBox(width: 24),
              _buildTestimonialCard(
                name: 'Maria Rodriguez, PT',
                title: 'Lead Physical Therapist, Coastal Health Partners',
                image: 'assets/images/testimonials/therapist1.jpg',
                content:
                    'My patients love the interactive elements of PhysioFlow. The AI form correction has been a game-changer for ensuring proper technique during home exercises.',
              ),
              const SizedBox(width: 24),
              _buildTestimonialCard(
                name: 'David Chen',
                title: 'CEO, RehabTech Solutions',
                image: 'assets/images/testimonials/executive1.jpg',
                content:
                    'After evaluating numerous platforms, PhysioFlow stood out for its comprehensive approach and ease of implementation. The ROI for our clinics has been substantial.',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTestimonialCard({
    required String name,
    required String title,
    required String image,
    required String content,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey[200],
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      image,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[300],
                          child: const Icon(
                            Icons.person,
                            color: Colors.grey,
                            size: 40,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Icon(
              Icons.format_quote,
              color: Color(0xFF2E7D32),
              size: 24,
            ),
            const SizedBox(height: 8),
            Text(
              content,
              style: const TextStyle(
                fontSize: 15,
                height: 1.6,
                color: Color(0xFF424242),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Add this method to the _CaseStudiesPageState class
  Widget _buildCallToAction() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 64),
      color: Colors.white,
      child: Column(
        children: [
          const Text(
            'Ready to achieve similar results?',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1B5E20),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Schedule a demo to see how PhysioFlow can transform your practice',
            style: TextStyle(
              fontSize: 18,
              color: Color(0xFF424242),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/contact');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2E7D32),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              textStyle: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            child: const Text('Request a Demo'),
          ),
        ],
      ),
    );
  }
}
