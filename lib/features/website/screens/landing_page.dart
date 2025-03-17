import 'package:flutter/material.dart';
import '../widgets/website_navbar.dart';
import '../widgets/website_footer.dart';
import '../../../core/routes/app_router.dart';
import '../../exercise/models/demo_exercises.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

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
            _buildHeroSection(context),
            _buildStatisticsBar(),
            _buildFeatureHighlights(context),
            _buildHowItWorks(),
            _buildTestimonialsSection(),
            _buildPartnerLogos(),
            const WebsiteFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 64, vertical: 100),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.white, Color(0xFFE8F5E9)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Transform Your Physical Therapy Practice',
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1B5E20),
                height: 1.2,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: 800,
              child: const Text(
                'PhysioFlow helps physical therapists manage patients, schedule appointments, and track treatment progress with AI-powered exercise monitoring technology.',
                style: TextStyle(
                  fontSize: 20,
                  color: Color(0xFF424242),
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2E7D32),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 16),
                    textStyle: const TextStyle(fontSize: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    // Schedule a demo button
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Schedule a Demo'),
                        content: const Text(
                            'Please fill out the form and we\'ll contact you shortly.'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Close'),
                          ),
                        ],
                      ),
                    );
                  },
                  child: const Text('Schedule a Demo'),
                ),
                const SizedBox(width: 16),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF2E7D32),
                    side: const BorderSide(color: Color(0xFF2E7D32)),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 16),
                    textStyle: const TextStyle(fontSize: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, AppRouter.featuresPage);
                  },
                  child: const Text('Learn More'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatisticsBar() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40),
      color: const Color(0xFF1B5E20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildStatItem('200+', 'Clinics'),
          _buildStatItem('3,500+', 'Therapists'),
          _buildStatItem('45,000+', 'Patients'),
          _buildStatItem('92%', 'Satisfaction Rate'),
        ],
      ),
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.white70,
          ),
        ),
      ],
    );
  }

  Widget _buildFeatureHighlights(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 64),
      color: Colors.white,
      child: Column(
        children: [
          const Text(
            'Powerful Tools for Modern Physical Therapy',
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
            'Streamline your practice with our comprehensive suite of tools',
            style: TextStyle(
              fontSize: 18,
              color: Color(0xFF424242),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 64),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildFeatureCard(
                icon: Icons.camera_alt,
                title: 'AI Exercise Monitoring',
                description:
                    'Real-time feedback on patient form using advanced computer vision technology to ensure proper exercise execution.',
                buttonText: 'See Demo',
                onPressed: () => Navigator.pushNamed(
                    context, AppRouter.exerciseMonitoring,
                    arguments: {'exercise': DemoExercise.shoulderFlexion()}),
              ),
              const SizedBox(width: 24),
              _buildFeatureCard(
                icon: Icons.insert_chart,
                title: 'Progress Tracking',
                description:
                    'Track and visualize patient recovery with comprehensive analytics and customizable reporting dashboards.',
                buttonText: 'Learn More',
                onPressed: () =>
                    Navigator.pushNamed(context, AppRouter.featuresPage),
              ),
              const SizedBox(width: 24),
              _buildFeatureCard(
                icon: Icons.calendar_today,
                title: 'Smart Scheduling',
                description:
                    'Streamline appointment management with our intelligent booking system that reduces no-shows and optimizes your calendar.',
                buttonText: 'Try It Out',
                onPressed: () => Navigator.pushNamed(context, AppRouter.login),
              ),
            ],
          ),
          const SizedBox(height: 80),
          _buildMainCallToAction(context),
        ],
      ),
    );
  }

  Widget _buildHowItWorks() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 64),
      color: const Color(0xFFF5F5F5),
      child: Column(
        children: [
          const Text(
            'How PhysioFlow Works',
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1B5E20),
              height: 1.2,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 64),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProcessStep(
                number: '01',
                title: 'Patient Assessment',
                description:
                    'Record patient history and perform initial assessments with our structured templates.',
              ),
              _buildProcessStep(
                number: '02',
                title: 'Exercise Prescription',
                description:
                    'Create personalized treatment plans from our library of AI-ready exercises.',
              ),
              _buildProcessStep(
                number: '03',
                title: 'Progress Monitoring',
                description:
                    'Track recovery progress with our AI tools that analyze exercise form and improvement.',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProcessStep({
    required String number,
    required String title,
    required String description,
  }) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF2E7D32),
                borderRadius: BorderRadius.circular(40),
              ),
              child: Text(
                number,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1B5E20),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              description,
              style: const TextStyle(
                fontSize: 16,
                height: 1.6,
                color: Color(0xFF424242),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureCard({
    required IconData icon,
    required String title,
    required String description,
    required String buttonText,
    required VoidCallback onPressed,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(24),
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
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFE8F5E9),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                size: 30,
                color: const Color(0xFF2E7D32),
              ),
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
            const SizedBox(height: 12),
            Text(
              description,
              style: const TextStyle(
                fontSize: 16,
                height: 1.5,
                color: Color(0xFF424242),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: onPressed,
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: const Color(0xFFE8F5E9),
                  foregroundColor: const Color(0xFF2E7D32),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(buttonText),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainCallToAction(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 48),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF2E7D32), Color(0xFF1B5E20)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Ready to transform your physical therapy practice?',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Join thousands of therapists who are improving patient outcomes with PhysioFlow.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () => Navigator.pushNamed(
                          context, AppRouter.therapistRegistration),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 32, vertical: 16),
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xFF2E7D32),
                        textStyle: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      child: const Text('Start Free Trial'),
                    ),
                    const SizedBox(width: 16),
                    TextButton(
                      onPressed: () =>
                          Navigator.pushNamed(context, AppRouter.contactPage),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 32, vertical: 16),
                        foregroundColor: Colors.white,
                        side: const BorderSide(color: Colors.white),
                      ),
                      child: const Text('Contact Sales'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Spacer(),
          Expanded(
            child: Image.asset(
              'assets/images/app-preview.png',
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTestimonialsSection() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 64),
      color: const Color(0xFFE8F5E9),
      child: Column(
        children: [
          const Text(
            'Trusted by Physical Therapists',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1B5E20),
            ),
          ),
          const SizedBox(height: 64),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTestimonialCard(
                quote:
                    '"PhysioFlow has transformed how I manage my practice. The time I save on administrative tasks allows me to focus more on my patients."',
                name: 'Dr. Sarah Johnson',
                title: 'Physical Therapist',
              ),
              const SizedBox(width: 24),
              _buildTestimonialCard(
                quote:
                    '"The patient management features are intuitive and the reporting tools give me valuable insights into treatment effectiveness."',
                name: 'Dr. Michael Chen',
                title: 'Sports Rehabilitation Specialist',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTestimonialCard({
    required String quote,
    required String name,
    required String title,
  }) {
    return Expanded(
      child: Card(
        elevation: 4,
        shadowColor: Colors.black26,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.format_quote,
                  size: 32, color: Color(0xFF2E7D32)),
              const SizedBox(height: 16),
              Text(
                quote,
                style: const TextStyle(
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                  color: Color(0xFF424242),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1B5E20),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF757575),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPartnerLogos() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 64),
      color: Colors.white,
      child: Column(
        children: [
          const Text(
            'Our Partners',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1B5E20),
            ),
          ),
          const SizedBox(height: 64),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Image.asset('assets/images/partner1.png', height: 60),
              Image.asset('assets/images/partner2.png', height: 60),
              Image.asset('assets/images/partner3.png', height: 60),
              Image.asset('assets/images/partner4.png', height: 60),
            ],
          ),
        ],
      ),
    );
  }
}

class NavbarItem extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const NavbarItem({
    super.key,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TextButton(
        onPressed: onTap,
        style: TextButton.styleFrom(
          foregroundColor: const Color(0xFF424242),
        ),
        child: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}
