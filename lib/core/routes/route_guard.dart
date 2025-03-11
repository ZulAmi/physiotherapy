import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../features/auth/providers/auth_provider.dart';
import '../enums/user_role.dart';

class RouteGuard extends StatelessWidget {
  final Widget child;
  final String routeName;
  final UserRole? requiredRole;
  final List<UserRole>? requiredRoles;

  const RouteGuard({
    super.key,
    required this.child,
    required this.routeName,
    this.requiredRole,
    this.requiredRoles,
  }) : assert((requiredRole != null) != (requiredRoles != null),
            'Either requiredRole or requiredRoles must be provided, not both');

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, auth, _) {
        final userRole = auth.user?.role;

        if (userRole == null) {
          return _buildAccessDenied(context, 'Please log in to continue');
        }

        bool hasAccess = false;

        if (requiredRole != null) {
          hasAccess = userRole == requiredRole;
        } else if (requiredRoles != null) {
          hasAccess = requiredRoles!.contains(userRole);
        }

        if (!hasAccess) {
          return _buildAccessDenied(
              context, 'You do not have permission to access this page');
        }

        return child;
      },
    );
  }

  Widget _buildAccessDenied(BuildContext context, String message) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.security,
              size: 64,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            Text(
              'Access Denied',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Go Back'),
            ),
          ],
        ),
      ),
    );
  }
}
