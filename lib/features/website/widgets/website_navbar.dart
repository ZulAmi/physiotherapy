import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/routes/app_router.dart';
import '../../../core/providers/language_provider.dart';
import '../../../core/localization/app_localizations.dart';

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
  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    final localizations = AppLocalizations.of(context);

    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: GestureDetector(
        onTap: () => Navigator.pushNamed(context, AppRouter.homePage),
        child: Row(
          children: [
            Image.asset('assets/images/logo.png', height: 40),
            const SizedBox(width: 8),
            Text(localizations.translate('app_title'),
                style: TextStyle(
                    color: Color(0xFF2E7D32), fontWeight: FontWeight.bold)),
          ],
        ),
      ),
      actions: [
        NavbarItem(
          title: localizations.translate('home'),
          isActive: widget.currentPage == 'home',
          onTap: () => Navigator.pushNamed(context, AppRouter.homePage),
        ),
        NavbarItem(
          title: localizations.translate('features'),
          isActive: widget.currentPage == 'features',
          onTap: () => Navigator.pushNamed(context, AppRouter.featuresPage),
        ),
        NavbarItem(
          title: localizations.translate('pricing'),
          isActive: widget.currentPage == 'pricing',
          onTap: () => Navigator.pushNamed(context, AppRouter.pricingPage),
        ),
        NavbarItem(
          title: localizations.translate('about'),
          isActive: widget.currentPage == 'about',
          onTap: () => Navigator.pushNamed(context, AppRouter.aboutPage),
        ),
        NavbarItem(
          title: localizations.translate('contact'),
          isActive: widget.currentPage == 'contact',
          onTap: () => Navigator.pushNamed(context, AppRouter.contactPage),
        ),
        const SizedBox(width: 16),

        // Language selector
        _buildLanguageSelector(context, languageProvider),

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
          child: Text(localizations.translate('sign_in')),
        ),
        const SizedBox(width: 24),
      ],
    );
  }

  // Language selector widget with flags
  Widget _buildLanguageSelector(
      BuildContext context, LanguageProvider languageProvider) {
    final localizations = AppLocalizations.of(context);
    final isEnglish = languageProvider.isEnglish;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: PopupMenuButton<String>(
        tooltip: localizations.translate('change_language'),
        offset: const Offset(0, 40),
        icon: Row(
          children: [
            // Show current flag
            _buildFlag(isEnglish ? 'us' : 'jp', width: 24),
            const SizedBox(width: 4),
            Icon(Icons.arrow_drop_down, color: Colors.grey[700]),
          ],
        ),
        onSelected: (String value) {
          if (value == 'en' && !isEnglish) {
            languageProvider.setLocale(const Locale('en', 'US'));
          } else if (value == 'ja' && isEnglish) {
            languageProvider.setLocale(const Locale('ja', 'JP'));
          }
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
            value: 'ja',
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

  // Helper to build flag image (same as before)
  Widget _buildFlag(String countryCode, {required double width}) {
    // Same implementation as before
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: Image.asset(
        'assets/images/flags/$countryCode.png',
        width: width,
        height: width * 0.75,
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
