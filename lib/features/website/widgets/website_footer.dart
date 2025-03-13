import 'package:flutter/material.dart';

class WebsiteFooter extends StatelessWidget {
  const WebsiteFooter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 64),
      color: const Color(0xFF1B5E20),
      child: Column(
        children: [
          // Main footer content
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Company info column
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Image.asset(
                          'assets/images/logo_white.png',
                          height: 40,
                          // If white logo isn't available, use ColorFiltered with the regular logo
                          errorBuilder: (context, _, __) => ColorFiltered(
                            colorFilter: const ColorFilter.mode(
                              Colors.white,
                              BlendMode.srcIn,
                            ),
                            child: Image.asset(
                              'assets/images/logo.png',
                              height: 40,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'PhysioFlow',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Transforming physiotherapy through AI-powered exercise monitoring and practice management tools.',
                      style: TextStyle(
                        color: Color(0xFFE8F5E9),
                        fontSize: 14,
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        _buildSocialIcon(Icons.facebook, onTap: () {}),
                        _buildSocialIcon(Icons.language, onTap: () {}),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 80),

              // Links column 1
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Company',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildFooterLink('Home', onTap: () {}),
                    _buildFooterLink('Features', onTap: () {}),
                    _buildFooterLink('Pricing', onTap: () {}),
                    _buildFooterLink('About Us', onTap: () {}),
                    _buildFooterLink('Contact', onTap: () {}),
                  ],
                ),
              ),

              // Links column 2
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Resources',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildFooterLink('Blog', onTap: () {}),
                    _buildFooterLink('Knowledge Base', onTap: () {}),
                    _buildFooterLink('Research', onTap: () {}),
                    _buildFooterLink('Case Studies', onTap: () {}),
                    _buildFooterLink('Documentation', onTap: () {}),
                  ],
                ),
              ),

              // Contact column
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Stay Updated',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Subscribe to our newsletter for the latest updates',
                      style: TextStyle(
                        color: Color(0xFFE8F5E9),
                        fontSize: 14,
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 16),
                              child: TextField(
                                style: const TextStyle(color: Colors.white),
                                decoration: const InputDecoration(
                                  hintText: 'Your email',
                                  hintStyle: TextStyle(
                                    color: Color(0xFFB2DFBC),
                                  ),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ),
                          TextButton(
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.white,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(8),
                                  bottomRight: Radius.circular(8),
                                ),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 16,
                              ),
                            ),
                            onPressed: () {},
                            child: const Text(
                              'Subscribe',
                              style: TextStyle(
                                color: Color(0xFF1B5E20),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: const [
                        Icon(
                          Icons.email_outlined,
                          color: Color(0xFFB2DFBC),
                          size: 18,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'contact@physioflow.com',
                          style: TextStyle(
                            color: Color(0xFFE8F5E9),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: const [
                        Icon(
                          Icons.phone_outlined,
                          color: Color(0xFFB2DFBC),
                          size: 18,
                        ),
                        SizedBox(width: 8),
                        Text(
                          '+1 (800) 123-4567',
                          style: TextStyle(
                            color: Color(0xFFE8F5E9),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 60),

          // Divider line
          Container(
            height: 1,
            color: Colors.white.withOpacity(0.2),
          ),

          const SizedBox(height: 24),

          // Bottom legal section
          Row(
            children: [
              Text(
                '© ${DateTime.now().year} PhysioFlow. All rights reserved.',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 14,
                ),
              ),
              const Spacer(),
              _buildLegalLink('Privacy Policy', onTap: () {}),
              _buildLegalLink('Terms of Service', onTap: () {}),
              _buildLegalLink('Cookie Policy', onTap: () {}),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSocialIcon(IconData icon, {required VoidCallback onTap}) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: IconButton(
        onPressed: onTap,
        icon: Icon(
          icon,
          color: Colors.white,
          size: 18,
        ),
        constraints: const BoxConstraints.tightFor(
          width: 40,
          height: 40,
        ),
      ),
    );
  }

  Widget _buildFooterLink(String text, {required VoidCallback onTap}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        child: Text(
          text,
          style: const TextStyle(
            color: Color(0xFFB2DFBC),
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildLegalLink(String text, {required VoidCallback onTap}) {
    return Padding(
      padding: const EdgeInsets.only(left: 24),
      child: InkWell(
        onTap: onTap,
        child: Text(
          text,
          style: TextStyle(
            color: Colors.white.withOpacity(0.7),
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
