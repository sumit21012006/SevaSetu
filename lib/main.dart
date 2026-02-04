import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'core/services/voice_agent_controller.dart';
import 'core/services/navigation_service.dart';
import 'core/services/auth_service.dart';
import 'core/config/firebase_config.dart';
import 'core/models/service.dart';
import 'ui/screens/auth/login_screen.dart';
import 'ui/screens/home/home_screen.dart';
import 'ui/screens/documents/document_vault_screen.dart';
import 'ui/screens/services/service_guidance_screen.dart';
import 'ui/screens/gr_explanation/gr_explanation_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase (optional for web demo)
  try {
    await FirebaseConfig.initializeFirebase();
  } catch (e) {
    print('Firebase not available for web demo: $e');
    // Continue without Firebase for web demo
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
        ChangeNotifierProvider(create: (_) => VoiceAgentController()),
        Provider(create: (_) => NavigationService()),
      ],
      child: const SevaSetuApp(),
    ),
  );
}

class SevaSetuApp extends StatelessWidget {
  const SevaSetuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SevaSetu',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      home: const AuthWrapper(),
      navigatorKey: Provider.of<NavigationService>(
        context,
        listen: false,
      ).navigatorKey,
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (context) => const AuthWrapper(),
        '/home': (context) => const HomeScreen(),
        '/login': (context) => const LoginScreen(),
        '/documents': (context) => const DocumentVaultScreen(),
        '/service': (context) => ServiceGuidanceScreen(
          service: ModalRoute.of(context)?.settings.arguments as Service?,
        ),
        '/gr-explanation': (context) => GRExplanationScreen(
          service: ModalRoute.of(context)?.settings.arguments as Service?,
        ),
      },
      onUnknownRoute: (settings) {
        return MaterialPageRoute(builder: (context) => const AuthWrapper());
      },
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    return StreamBuilder(
      stream: authService.authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // For demo mode, we need to check if user is authenticated
        // Since we're using mock authentication, we'll use a different approach
        if (snapshot.hasData ||
            snapshot.connectionState == ConnectionState.active) {
          // Check if we have a current user or if demo mode is active
          if (authService.currentUser != null) {
            return const HomeScreen();
          } else {
            // For demo mode, we need to track authentication state differently
            // Let's use a simple approach - if we're in web and demo worked, show home
            return const HomeScreen();
          }
        } else {
          return const LoginScreen();
        }
      },
    );
  }
}
