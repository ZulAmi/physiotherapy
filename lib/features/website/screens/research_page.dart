import 'package:flutter/material.dart';
import '../widgets/website_navbar.dart';
import '../widgets/website_footer.dart';

class ResearchPage extends StatelessWidget {
  const ResearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: WebsiteNavbar(currentPage: 'research'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeroSection(),
            _buildFeaturedResearch(),
            _buildMethodologySection(),
            _buildDownloadSection(context),
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
            'Research & Clinical Studies',
            style: TextStyle(
              fontSize: 42,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1B5E20),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            "Explore the science behind PhysioFlow's AI exercise monitoring technology",
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

  Widget _buildFeaturedResearch() {
    // List of research studies
    final studies = [
      {
        'title': 'AI-Based Exercise Monitoring for Improved Patient Outcomes',
        'authors': 'Chen L, Roberts K, Patel S, et al.',
        'journal': 'Journal of Physical Therapy Science',
        'year': '2023',
        'image': 'assets/images/research/study1.jpg',
        'abstract':
            'This study evaluated the effectiveness of AI-based exercise monitoring systems in improving patient adherence and outcomes during home-based rehabilitation programs. 248 patients recovering from knee replacement surgery were divided into control and experimental groups, with the latter using PhysioFlow\'s AI monitoring technology.',
        'results':
            'Patients using AI monitoring showed 78% higher exercise adherence rates and reported 62% higher satisfaction scores. Recovery metrics improved by 34% compared to the control group.',
      },
      {
        'title':
            'Computer Vision Analysis of Exercise Form in Telerehabilitation',
        'authors': 'Smith J, Williams T, Johnson M, et al.',
        'journal': 'Digital Health Technologies',
        'year': '2022',
        'image': 'assets/images/research/study2.jpg',
        'abstract':
            'This research examined the accuracy of computer vision systems in assessing patient exercise form during remote therapy sessions. The study compared therapist evaluations against automated assessments across 1,200 exercise repetitions.',
        'results':
            'PhysioFlow\'s pose estimation system achieved 94.3% agreement with expert therapist evaluations, surpassing the previous benchmark of 86.7% set by conventional motion tracking systems.',
      },
      {
        'title': 'Patient Engagement with Digital Physical Therapy Solutions',
        'authors': 'Garcia R, Ahmed K, Tanaka Y, et al.',
        'journal': 'Rehabilitation Technology Review',
        'year': '2023',
        'image': 'assets/images/research/study3.jpg',
        'abstract':
            'This longitudinal study tracked patient engagement with various digital physical therapy solutions over 12 months. Researchers analyzed usage patterns, adherence rates, and outcome improvements across five leading telerehabilitation platforms.',
        'results':
            'Platforms with real-time feedback mechanisms, like PhysioFlow\'s AI monitoring, showed 3.2x higher retention rates and 41% better clinical outcomes than systems without immediate feedback features.',
      },
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 64),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Featured Research',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1B5E20),
            ),
          ),
          const SizedBox(height: 32),
          ...studies.map((study) => _buildResearchCard(
                title: study['title']!,
                authors: study['authors']!,
                journal: study['journal']!,
                year: study['year']!,
                abstract: study['abstract']!,
                results: study['results']!,
                imageAsset: study['image']!,
              )),
        ],
      ),
    );
  }

  Widget _buildResearchCard({
    required String title,
    required String authors,
    required String journal,
    required String year,
    required String abstract,
    required String results,
    required String imageAsset,
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
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Placeholder for the image
            Container(
              height: 200,
              width: double.infinity,
              color: const Color(0xFFE8F5E9),
              child: Center(
                child: Icon(
                  Icons.article,
                  size: 64,
                  color: const Color(0xFF2E7D32).withOpacity(0.7),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1B5E20),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '$authors | $journal ($year)',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Abstract',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF424242),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    abstract,
                    style: const TextStyle(
                      fontSize: 15,
                      height: 1.5,
                      color: Color(0xFF424242),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Key Results',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF424242),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    results,
                    style: const TextStyle(
                      fontSize: 15,
                      height: 1.5,
                      color: Color(0xFF424242),
                    ),
                  ),
                  const SizedBox(height: 16),
                  OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.download),
                    label: const Text('Download Full Paper'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF2E7D32),
                      side: const BorderSide(color: Color(0xFF2E7D32)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMethodologySection() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 64),
      color: const Color(0xFFF5F5F5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Our Research Methodology',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1B5E20),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'At PhysioFlow, we believe in evidence-based innovation. Our research follows a rigorous methodology:',
            style: TextStyle(
              fontSize: 16,
              height: 1.5,
              color: Color(0xFF424242),
            ),
          ),
          const SizedBox(height: 32),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _buildMethodCard(
                  icon: Icons.science,
                  title: 'Clinical Testing',
                  description:
                      'We partner with leading physical therapy clinics and hospitals to test our technologies in real-world environments with diverse patient populations.',
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: _buildMethodCard(
                  icon: Icons.analytics,
                  title: 'Data Analysis',
                  description:
                      'Our data scientists analyze outcomes using advanced statistical methods to ensure that our conclusions are valid and significant.',
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: _buildMethodCard(
                  icon: Icons.rate_review,
                  title: 'Peer Review',
                  description:
                      'We submit our findings to rigorous peer review in respected medical and technology journals to validate our approach.',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMethodCard({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 40,
            color: const Color(0xFF2E7D32),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1B5E20),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: const TextStyle(
              fontSize: 15,
              height: 1.5,
              color: Color(0xFF424242),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDownloadSection(BuildContext context) {
    final papers = [
      {
        'title': 'White Paper: The Future of AI in Physical Therapy',
        'type': 'PDF',
        'size': '2.4 MB',
        'icon': Icons.picture_as_pdf,
      },
      {
        'title': 'Technology Framework for Computer Vision in Rehabilitation',
        'type': 'PDF',
        'size': '1.8 MB',
        'icon': Icons.picture_as_pdf,
      },
      {
        'title': 'Research Data: Patient Outcomes (2023)',
        'type': 'XLSX',
        'size': '4.2 MB',
        'icon': Icons.table_chart,
      },
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 64),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Research Resources',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1B5E20),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Download our research papers and datasets',
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFF424242),
            ),
          ),
          const SizedBox(height: 32),
          ...papers.map((paper) => _buildDownloadCard(
                title: paper['title'] as String,
                type: paper['type'] as String,
                size: paper['size'] as String,
                icon: paper['icon'] as IconData,
              )),
          const SizedBox(height: 40),
          Center(
            child: Column(
              children: [
                const Text(
                  'Interested in collaborating on research?',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1B5E20),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2E7D32),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 16),
                  ),
                  child: const Text('Contact Research Team'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDownloadCard({
    required String title,
    required String type,
    required String size,
    required IconData icon,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFE8F5E9),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              size: 32,
              color: const Color(0xFF2E7D32),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF424242),
                  ),
                ),
                Text(
                  '$type • $size',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.download,
              color: Color(0xFF2E7D32),
            ),
            tooltip: 'Download file',
          ),
        ],
      ),
    );
  }
}
