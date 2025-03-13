import 'package:flutter/material.dart';
import '../widgets/website_navbar.dart';
import '../widgets/website_footer.dart';
import '../../core/routes/app_router.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: WebsiteNavbar(currentPage: 'home'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Hero Section
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 64, vertical: 120),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.white, Color(0xFFE8F5E9)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Row(
                children: [
                  // Left side text
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Transform Your\nPhysiotherapy Practice',
                          style: TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1B5E20),
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 24),
                        const Text(
                          'PhysioFlow combines AI-powered exercise monitoring with powerful practice management tools to improve patient outcomes.',
                          style: TextStyle(
                            fontSize: 18,
                            color: Color(0xFF424242),
                            height: 1.6,
                          ),
                        ),
                        const SizedBox(height: 40),
                        Row(
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF2E7D32),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 32,
                                  vertical: 18,
                                ),
                                textStyle: const TextStyle(fontSize: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onPressed: () {},
                              child: const Text('Request Demo'),
                            ),
                            const SizedBox(width: 16),
                            TextButton(
                              style: TextButton.styleFrom(
                                foregroundColor: const Color(0xFF2E7D32),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 18,
                                ),
                                textStyle: const TextStyle(fontSize: 16),
                              ),
                              onPressed: () {},
                              child: const Row(
                                children: [
                                  Text('Watch Video'),
                                  SizedBox(width: 8),
                                  Icon(Icons.play_circle_outline, size: 20),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Right side image
                  Expanded(
                    child: Image.asset(
                      'assets/images/hero_image.png',
                      height: 450,
                    ),
                  ),
                ],
              ),
            ),

            // Stats section
            Container(
              padding: const EdgeInsets.symmetric(vertical: 80),
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildStatItem('200+', 'Clinics'),
                  _buildStatItem('2,500+', 'Therapists'),
                  _buildStatItem('120,000+', 'Patients'),
                  _buildStatItem('98%', 'Satisfaction'),
                ],
              ),
            ),

            // Features section
            Container(
              padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 64),
              color: const Color(0xFFF5F5F5),
              child: Column(
                children: [
                  const Text(
                    'Powerful Tools for Modern Physiotherapy',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1B5E20),
                      height: 1.2,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Everything you need to streamline your practice and improve patient outcomes',
                    style: TextStyle(
                      fontSize: 18,
                      color: Color(0xFF424242),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 64),
                  // Feature items in grid
                  GridView.count(
                    crossAxisCount: 3,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 40,
                    crossAxisSpacing: 40,
                    children: [
                      _buildFeatureItem(
                        icon: Icons.monitor_heart,
                        title: 'AI Exercise Monitoring',
                        description:
                            'Real-time feedback ensures patients perform exercises correctly.',
                      ),
                      _buildFeatureItem(
                        icon: Icons.calendar_month,
                        title: 'Smart Scheduling',
                        description:
                            'Effortlessly manage appointments with automated reminders.',
                      ),
                      _buildFeatureItem(
                        icon: Icons.dashboard_customize,
                        title: 'Customizable Plans',
                        description:
                            'Create personalized treatment plans with our exercise library.',
                      ),
                      _buildFeatureItem(
                        icon: Icons.analytics,
                        title: 'Detailed Analytics',
                        description:
                            'Track patient progress and practice performance.',
                      ),
                      _buildFeatureItem(
                        icon: Icons.video_call,
                        title: 'Telehealth Integration',
                        description:
                            'Conduct virtual consultations seamlessly.',
                      ),
                      _buildFeatureItem(
                        icon: Icons.security,
                        title: 'HIPAA Compliant',
                        description:
                            'Keep patient data secure with enterprise-grade security.',
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // CTA Section
            Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 100, horizontal: 64),
              color: Colors.white,
              child: Row(
                children: [
                  // Left side image
                  Expanded(
                    child: Image.asset(
                      'assets/images/cta_image.png',
                      height: 400,
                    ),
                  ),
                  const SizedBox(width: 80),
                  // Right side text
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Ready to transform your practice?',
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1B5E20),
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 24),
                        const Text(
                          'Join hundreds of clinics already using PhysioFlow to improve patient outcomes and streamline their operations.',
                          style: TextStyle(
                            fontSize: 18,
                            color: Color(0xFF424242),
                            height: 1.6,
                          ),
                        ),
                        const SizedBox(height: 40),
                        Row(
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF2E7D32),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 32,
                                  vertical: 18,
                                ),
                                textStyle: const TextStyle(fontSize: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onPressed: () {},
                              child: const Text('Request Demo'),
                            ),
                            const SizedBox(width: 16),
                            TextButton(
                              style: TextButton.styleFrom(
                                foregroundColor: const Color(0xFF2E7D32),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 18,
                                ),
                                textStyle: const TextStyle(fontSize: 16),
                              ),
                              onPressed: () {},
                              child: const Text('View Pricing'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Footer
            const WebsiteFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 48,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2E7D32),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 18,
            color: Color(0xFF616161),
          ),
        ),
      ],
    );
  }

  Widget _buildFeatureItem({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 48,
            color: const Color(0xFF2E7D32),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1B5E20),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            description,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF616161),
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
