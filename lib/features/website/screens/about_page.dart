import 'package:flutter/material.dart';
import '../widgets/website_navbar.dart';
import '../widgets/website_footer.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: WebsiteNavbar(currentPage: 'about'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header Section
            Container(
              padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 64),
              color: const Color(0xFFE8F5E9),
              child: Column(
                children: const [
                  Text(
                    'About PhysioFlow',
                    style: TextStyle(
                      fontSize: 42,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1B5E20),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 24),
                  Text(
                    'Our mission is to revolutionize physiotherapy through cutting-edge technology\nthat empowers both therapists and patients.',
                    style: TextStyle(
                      fontSize: 18,
                      height: 1.6,
                      color: Color(0xFF424242),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            // Our Story Section
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 64),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Left side image
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        'assets/images/our_story.png',
                        height: 400,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            height: 400,
                            decoration: BoxDecoration(
                              color: const Color(0xFFE8F5E9),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.people,
                                size: 80,
                                color: Color(0xFF2E7D32),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 64),
                  // Right side text
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Our Story',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1B5E20),
                          ),
                        ),
                        SizedBox(height: 24),
                        Text(
                          'PhysioFlow began in 2021 when our founder, recognized a significant gap in physiotherapy care. As a practicing physiotherapist for over 15 years, she observed that patients often struggled with maintaining proper form during home exercises, leading to slower recovery and occasional injuries.',
                          style: TextStyle(
                            fontSize: 16,
                            height: 1.8,
                            color: Color(0xFF424242),
                          ),
                        ),
                        SizedBox(height: 16),
                        Text(
                          "Leveraging her medical expertise and partnering with AI specialists and software engineers, Dr. Chen developed the first prototype of PhysioFlow's AI exercise monitoring system. After successful clinical trials showing 78% improvement in patient outcomes compared to traditional methods, PhysioFlow was officially launched in 2022.",
                          style: TextStyle(
                            fontSize: 16,
                            height: 1.8,
                            color: Color(0xFF424242),
                          ),
                        ),
                        SizedBox(height: 16),
                        Text(
                          "Today, we're proud to serve over 200 clinics nationwide, helping thousands of patients recover faster and with better results.",
                          style: TextStyle(
                            fontSize: 16,
                            height: 1.8,
                            color: Color(0xFF424242),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Our Values Section
            Container(
              padding: const EdgeInsets.symmetric(vertical: 80),
              color: const Color(0xFFF5F5F5),
              child: Column(
                children: [
                  const Text(
                    'Our Values',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1B5E20),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'The principles that guide everything we do',
                    style: TextStyle(
                      fontSize: 18,
                      color: Color(0xFF424242),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 64),
                  // Values in grid
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 64),
                    child: GridView.count(
                      crossAxisCount: 3,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      mainAxisSpacing: 40,
                      crossAxisSpacing: 40,
                      children: [
                        _buildValueItem(
                          icon: Icons.emoji_people,
                          title: 'Patient-Centric',
                          description:
                              'We design every feature with patient outcomes as our top priority.',
                        ),
                        _buildValueItem(
                          icon: Icons.verified,
                          title: 'Clinical Excellence',
                          description:
                              'We maintain the highest standards of medical and scientific integrity.',
                        ),
                        _buildValueItem(
                          icon: Icons.psychology,
                          title: 'Continuous Innovation',
                          description:
                              'We constantly seek new ways to improve rehabilitation technology.',
                        ),
                        _buildValueItem(
                          icon: Icons.accessibility_new,
                          title: 'Accessibility',
                          description:
                              'We believe quality care should be available to everyone.',
                        ),
                        _buildValueItem(
                          icon: Icons.people_alt,
                          title: 'Collaborative Care',
                          description:
                              'We empower the relationship between therapists and patients.',
                        ),
                        _buildValueItem(
                          icon: Icons.privacy_tip,
                          title: 'Privacy & Security',
                          description:
                              'We protect patient data with the highest security standards.',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Leadership Team Section
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 64),
              child: Column(
                children: [
                  const Text(
                    'Our Leadership Team',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1B5E20),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Meet the experts behind PhysioFlow',
                    style: TextStyle(
                      fontSize: 18,
                      color: Color(0xFF424242),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 64),
                  // Team members
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildTeamMember(
                        name: 'Dr. Sarah Chen',
                        position: 'Founder & CEO',
                        bio:
                            'Former head of physiotherapy at Metro General Hospital with 15+ years of clinical experience.',
                      ),
                      const SizedBox(width: 40),
                      _buildTeamMember(
                        name: 'Michael Rodriguez',
                        position: 'CTO',
                        bio:
                            'AI specialist with previous experience at leading tech companies developing computer vision systems.',
                      ),
                      const SizedBox(width: 40),
                      _buildTeamMember(
                        name: 'Dr. James Wilson',
                        position: 'Chief Medical Officer',
                        bio:
                            'Board-certified orthopedic specialist focused on evidence-based rehabilitation protocols.',
                      ),
                    ],
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

  Widget _buildValueItem({
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

  Widget _buildTeamMember({
    required String name,
    required String position,
    required String bio,
  }) {
    return Container(
      width: 280,
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
        children: [
          CircleAvatar(
            radius: 60,
            backgroundColor: const Color(0xFFE8F5E9),
            child: Icon(
              Icons.person,
              size: 60,
              color: const Color(0xFF2E7D32),
            ),
          ),
          const SizedBox(height: 16),
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
            position,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF616161),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            bio,
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
