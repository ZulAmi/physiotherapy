import 'package:flutter/material.dart';
import '../widgets/website_navbar.dart';
import '../widgets/website_footer.dart';

class FeaturesPage extends StatelessWidget {
  const FeaturesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: WebsiteNavbar(currentPage: 'features'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Hero section
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 64, vertical: 80),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.white, Color(0xFFE8F5E9)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Column(
                children: [
                  const Text(
                    'Powerful Features for Modern Physiotherapy',
                    style: TextStyle(
                      fontSize: 42,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1B5E20),
                      height: 1.2,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Everything you need to manage your practice, track patient progress, and deliver outstanding care.',
                    style: TextStyle(
                      fontSize: 18,
                      color: Color(0xFF424242),
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 60),
                  Image.asset(
                    'assets/images/features_hero.png',
                    height: 400,
                    fit: BoxFit.contain,
                  ),
                ],
              ),
            ),

            // Feature Categories
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 64),
              child: Column(
                children: [
                  const Text(
                    'Comprehensive Solution',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1B5E20),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Designed specifically for physiotherapy practices',
                    style: TextStyle(
                      fontSize: 18,
                      color: Color(0xFF424242),
                    ),
                  ),
                  const SizedBox(height: 64),

                  // Feature Groups
                  _buildFeatureGroup(
                    title: 'Patient Management',
                    icon: Icons.people,
                    features: [
                      'Comprehensive patient records',
                      'Medical history tracking',
                      'Treatment plan management',
                      'Progress notes and documentation',
                      'Customizable assessment forms'
                    ],
                  ),

                  const SizedBox(height: 48),

                  _buildFeatureGroup(
                    title: 'AI-Powered Exercise Monitoring',
                    icon: Icons.sports_gymnastics,
                    features: [
                      'Real-time exercise form analysis',
                      'Posture correction feedback',
                      'Progress tracking with visual analytics',
                      'Customizable exercise programs',
                      'Video recording and playback'
                    ],
                  ),

                  const SizedBox(height: 48),

                  _buildFeatureGroup(
                    title: 'Practice Management',
                    icon: Icons.business,
                    features: [
                      'Appointment scheduling and reminders',
                      'Billing and payment processing',
                      'Insurance claim management',
                      'Staff scheduling and management',
                      'Financial reporting and analytics'
                    ],
                  ),
                ],
              ),
            ),

            // Integration section
            Container(
              padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 64),
              color: const Color(0xFFE8F5E9),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Seamless Integration',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1B5E20),
                          ),
                        ),
                        const SizedBox(height: 24),
                        const Text(
                          'PhysioFlow works with your existing tools and systems',
                          style: TextStyle(
                            fontSize: 18,
                            color: Color(0xFF424242),
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 32),

                        // Integration items
                        _buildIntegrationItem(
                          title: 'Electronic Health Records',
                          description: 'Connects with major EHR systems',
                        ),
                        _buildIntegrationItem(
                          title: 'Payment Processors',
                          description: 'Works with leading payment gateways',
                        ),
                        _buildIntegrationItem(
                          title: 'Telehealth Platforms',
                          description:
                              'Integrates with video conferencing tools',
                        ),
                        _buildIntegrationItem(
                          title: 'Calendar Applications',
                          description:
                              'Syncs with Google, Apple, and Outlook calendars',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 40),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        children: [
                          Image.asset(
                            'assets/images/integrations.png',
                            height: 300,
                            fit: BoxFit.contain,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // CTA Section
            Container(
              padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 64),
              child: Column(
                children: [
                  const Text(
                    'Ready to experience PhysioFlow?',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1B5E20),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Join thousands of physical therapists who have transformed their practice',
                    style: TextStyle(
                      fontSize: 18,
                      color: Color(0xFF424242),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2E7D32),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 20),
                      textStyle: const TextStyle(fontSize: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {},
                    child: const Text('Request a Demo'),
                  ),
                ],
              ),
            ),

            // Footer would go here
            const WebsiteFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureGroup({
    required String title,
    required IconData icon,
    required List<String> features,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: const Color(0xFFE8F5E9),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            size: 32,
            color: const Color(0xFF2E7D32),
          ),
        ),
        const SizedBox(width: 24),
        Expanded(
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
              const SizedBox(height: 16),
              ...features
                  .map((feature) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.check_circle,
                              color: Color(0xFF2E7D32),
                              size: 20,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                feature,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Color(0xFF424242),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ))
                  .toList(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildIntegrationItem({
    required String title,
    required String description,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Icon(
              Icons.link,
              color: Color(0xFF2E7D32),
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
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1B5E20),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF424242),
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
