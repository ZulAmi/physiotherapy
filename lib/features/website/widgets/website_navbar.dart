import 'package:flutter/material.dart';
import '../../../core/routes/app_router.dart';

// Convert to StatefulWidget to manage language state
class WebsiteNavbar extends StatefulWidget {
  final String currentPage;

  const WebsiteNavbar({
    super.key,
    required this.currentPage,
  });

  @override
  State<WebsiteNavbar> createState() => _WebsiteNavbarState();
}

class _WebsiteNavbarState extends State<WebsiteNavbar> {
  // Default language is English
  bool _isEnglish = true;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: GestureDetector(
        onTap: () => Navigator.pushNamed(context, AppRouter.homePage),
        child: Row(
          children: [
            Image.asset('assets/images/logo.png', height: 40),
            const SizedBox(width: 8),
            const Text('PhysioFlow',
                style: TextStyle(
                    color: Color(0xFF2E7D32), fontWeight: FontWeight.bold)),
          ],
        ),
      ),
      actions: [
        NavbarItem(
          title: _isEnglish ? 'Home' : 'ホーム',
          isActive: widget.currentPage == 'home',
          onTap: () => Navigator.pushNamed(context, AppRouter.homePage),
        ),
        NavbarItem(
          title: _isEnglish ? 'Features' : '機能',
          isActive: widget.currentPage == 'features',
          onTap: () => Navigator.pushNamed(context, AppRouter.featuresPage),
        ),
        NavbarItem(
          title: _isEnglish ? 'Pricing' : '料金',
          isActive: widget.currentPage == 'pricing',
          onTap: () => Navigator.pushNamed(context, AppRouter.pricingPage),
        ),
        NavbarItem(
          title: _isEnglish ? 'About' : '会社概要',
          isActive: widget.currentPage == 'about',
          onTap: () => Navigator.pushNamed(context, AppRouter.aboutPage),
        ),
        NavbarItem(
          title: _isEnglish ? 'Contact' : 'お問い合わせ',
          isActive: widget.currentPage == 'contact',
          onTap: () => Navigator.pushNamed(context, AppRouter.contactPage),
        ),
        const SizedBox(width: 16),

        // Language selector
        _buildLanguageSelector(),

        const SizedBox(width: 16),

        // Sign In button
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF2E7D32),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: () => Navigator.pushNamed(context, AppRouter.login),
          child: Text(_isEnglish ? 'Sign In' : 'ログイン'),
        ),
        const SizedBox(width: 24),
      ],
    );
  }

  // Language selector widget with flags
  Widget _buildLanguageSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: PopupMenuButton<String>(
        tooltip: _isEnglish ? 'Change language' : '言語を変更',
        offset: const Offset(0, 40),
        icon: Row(
          children: [
            // Show current flag
            _buildFlag(_isEnglish ? 'us' : 'jp', width: 24),
            const SizedBox(width: 4),
            Icon(Icons.arrow_drop_down, color: Colors.grey[700]),
          ],
        ),
        onSelected: (String value) {
          setState(() {
            _isEnglish = value == 'en';
          });
        },
        itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
          PopupMenuItem<String>(
            value: 'en',
            child: Row(
              children: [
                _buildFlag('us', width: 24),
                const SizedBox(width: 8),
                const Text('English'),
              ],
            ),
          ),
          PopupMenuItem<String>(
            value: 'jp',
            child: Row(
              children: [
                _buildFlag('jp', width: 24),
                const SizedBox(width: 8),
                const Text('日本語'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper to build flag image
  Widget _buildFlag(String countryCode, {required double width}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: Image.asset(
        'assets/images/flags/$countryCode.png',
        width: width,
        height: width * 0.75, // Standard flag aspect ratio (4:3)
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: width,
            height: width * 0.75,
            color: Colors.grey[200],
            child: Center(
              child: Text(
                countryCode.toUpperCase(),
                style: TextStyle(fontSize: width * 0.4, color: Colors.grey),
              ),
            ),
          );
        },
      ),
    );
  }
}

// Keep the existing NavbarItem class
class NavbarItem extends StatelessWidget {
  final String title;
  final bool isActive;
  final VoidCallback onTap;

  const NavbarItem({
    super.key,
    required this.title,
    required this.onTap,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TextButton(
        onPressed: onTap,
        style: TextButton.styleFrom(
          foregroundColor:
              isActive ? const Color(0xFF2E7D32) : const Color(0xFF424242),
        ),
        child: Text(
          title,
          style: TextStyle(
            fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
            decoration:
                isActive ? TextDecoration.underline : TextDecoration.none,
            decorationColor: const Color(0xFF2E7D32),
            decorationThickness: 2,
          ),
        ),
      ),
    );
  }
}
