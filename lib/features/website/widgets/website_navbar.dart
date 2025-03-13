import 'package:flutter/material.dart';
import '../../../core/routes/app_router.dart';

class WebsiteNavbar extends StatelessWidget {
  final String currentPage;

  const WebsiteNavbar({
    super.key,
    required this.currentPage,
  });

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
          title: 'Home',
          isActive: currentPage == 'home',
          onTap: () => Navigator.pushNamed(context, AppRouter.homePage),
        ),
        NavbarItem(
          title: 'Features',
          isActive: currentPage == 'features',
          onTap: () => Navigator.pushNamed(context, AppRouter.featuresPage),
        ),
        NavbarItem(
          title: 'Pricing',
          isActive: currentPage == 'pricing',
          onTap: () => Navigator.pushNamed(context, AppRouter.pricingPage),
        ),
        NavbarItem(
          title: 'About',
          isActive: currentPage == 'about',
          onTap: () => Navigator.pushNamed(context, AppRouter.aboutPage),
        ),
        NavbarItem(
          title: 'Contact',
          isActive: currentPage == 'contact',
          onTap: () => Navigator.pushNamed(context, AppRouter.contactPage),
        ),
        const SizedBox(width: 16),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF2E7D32),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: () => Navigator.pushNamed(context, AppRouter.login),
          child: const Text('Sign In'),
        ),
        const SizedBox(width: 24),
      ],
    );
  }
}

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
