import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'features/auth/providers/auth_provider.dart';
import 'features/exercise/providers/exercise_provider.dart';
import 'features/patient/providers/patient_provider.dart';
import 'features/therapist/providers/therapist_provider.dart';
import 'core/routes/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/services/firebase_service.dart';
import 'core/providers/language_provider.dart';
import 'core/localization/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase first
  await FirebaseService.initialize();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => PatientProvider()),
        ChangeNotifierProvider(create: (_) => ExerciseProvider()),
        ChangeNotifierProvider(create: (_) => TherapistProvider()),
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
      ],
      child: const PhysioFlowApp(),
    ),
  );
}

class PhysioFlowApp extends StatelessWidget {
  const PhysioFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageProvider>(
      builder: (context, languageProvider, child) {
        return MaterialApp(
          title: 'PhysioFlow',
          locale: languageProvider.currentLocale,
          supportedLocales: const [
            Locale('en', 'US'),
            Locale('ja', 'JP'),
          ],
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          onGenerateRoute: AppRouter.onGenerateRoute,
          initialRoute: AppRouter.landingPage,
        );
      },
    );
  }
}
