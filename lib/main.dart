import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'services/auth_service.dart';
import 'services/voice_agent_controller.dart';
import 'services/document_provider.dart';
import 'screens/auth_screen.dart';
import 'screens/home_screen.dart';
import 'screens/document_vault_screen.dart';
import 'screens/service_guidance_screen.dart';
import 'screens/document_upload_screen.dart';
import 'screens/gr_explanation_screen.dart';
import 'screens/profile_screen.dart';
import 'theme/design_system.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyBUE2OaAwdcK3MqxPHs0Wmb6iAcb-vHsoQ",
        authDomain: "svasetu-app.firebaseapp.com",
        projectId: "svasetu-app",
        storageBucket: "svasetu-app.firebasestorage.app",
        messagingSenderId: "720846480272",
        appId: "1:720846480272:web:787489877603ca1964c915",
      ),
    );
    print('✅ Firebase initialized successfully');
  } catch (e) {
    print('⚠️ Firebase initialization: $e');
  }

  runApp(const SevaSetu());
}

class SevaSetu extends StatelessWidget {
  const SevaSetu({super.key});

  @override
  Widget build(BuildContext context) {
    final navigatorKey = GlobalKey<NavigatorState>();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
        ChangeNotifierProxyProvider<AuthService, DocumentProvider>(
          create: (_) => DocumentProvider(),
          update: (_, auth, docProvider) {
            docProvider?.setUserId(auth.userId);
            return docProvider!;
          },
        ),
        ChangeNotifierProvider(
            create: (_) => VoiceAgentController(navigatorKey)),
      ],
      child: MaterialApp(
        title: 'SevaSetu',
        navigatorKey: navigatorKey,
        theme: ThemeData(
          // Primary Theme
          primaryColor: SevaSetuTheme.primaryBlue,
          colorScheme: ColorScheme.fromSeed(
            seedColor: SevaSetuTheme.primaryBlue,
            primary: SevaSetuTheme.primaryBlue,
            secondary: SevaSetuTheme.secondaryBlue,
          ),

          // Typography
          fontFamily: 'Inter',
          textTheme: const TextTheme(
            displayLarge: SevaSetuTheme.heading1,
            displayMedium: SevaSetuTheme.heading2,
            displaySmall: SevaSetuTheme.heading3,
            bodyLarge: SevaSetuTheme.bodyLarge,
            bodyMedium: SevaSetuTheme.bodyMedium,
            bodySmall: SevaSetuTheme.bodySmall,
            labelSmall: SevaSetuTheme.caption,
          ),

          // App Bar
          appBarTheme: AppBarTheme(
            backgroundColor: SevaSetuTheme.surface,
            elevation: 0,
            centerTitle: true,
            titleTextStyle: SevaSetuTheme.heading3.copyWith(
              color: SevaSetuTheme.textPrimary,
              fontWeight: FontWeight.bold,
            ),
            iconTheme: const IconThemeData(color: SevaSetuTheme.textPrimary),
            actionsIconTheme:
                const IconThemeData(color: SevaSetuTheme.textPrimary),
          ),

          // Buttons
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: SevaSetuTheme.primaryBlue,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: SevaSetuTheme.borderRadiusMD,
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: SevaSetuTheme.spacingLG,
                vertical: SevaSetuTheme.spacingMD,
              ),
              elevation: SevaSetuTheme.elevationMedium,
              shadowColor: SevaSetuTheme.primaryBlue.withOpacity(0.3),
            ),
          ),

          // Text Fields
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: SevaSetuTheme.surface,
            border: OutlineInputBorder(
              borderRadius: SevaSetuTheme.borderRadiusMD,
              borderSide: BorderSide(color: SevaSetuTheme.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: SevaSetuTheme.borderRadiusMD,
              borderSide: BorderSide(color: SevaSetuTheme.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: SevaSetuTheme.borderRadiusMD,
              borderSide:
                  BorderSide(color: SevaSetuTheme.primaryBlue, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: SevaSetuTheme.borderRadiusMD,
              borderSide: BorderSide(color: SevaSetuTheme.errorRed, width: 2),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: SevaSetuTheme.borderRadiusMD,
              borderSide: BorderSide(color: SevaSetuTheme.errorRed, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: SevaSetuTheme.spacingMD,
              vertical: SevaSetuTheme.spacingSM,
            ),
            labelStyle: SevaSetuTheme.bodyMedium
                .copyWith(color: SevaSetuTheme.textSecondary),
            hintStyle: SevaSetuTheme.bodyMedium
                .copyWith(color: SevaSetuTheme.textTertiary),
          ),

          // Navigation Bar
          navigationBarTheme: NavigationBarThemeData(
            backgroundColor: SevaSetuTheme.surface,
            elevation: 0,
            indicatorColor: SevaSetuTheme.primaryBlue.withOpacity(0.1),
            labelTextStyle: MaterialStateProperty.all(
              SevaSetuTheme.bodySmall.copyWith(
                color: SevaSetuTheme.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          // SnackBars
          snackBarTheme: SnackBarThemeData(
            backgroundColor: SevaSetuTheme.textPrimary,
            actionTextColor: SevaSetuTheme.primaryBlue,
            contentTextStyle:
                SevaSetuTheme.bodyMedium.copyWith(color: Colors.white),
            shape: RoundedRectangleBorder(
              borderRadius: SevaSetuTheme.borderRadiusMD,
            ),
            behavior: SnackBarBehavior.floating,
          ),

          // Use Material 3
          useMaterial3: true,
        ),
        home: Consumer<AuthService>(
          builder: (context, auth, _) =>
              auth.isAuthenticated ? const MainScreen() : const AuthScreen(),
        ),
        routes: {
          '/home': (_) => const HomeScreen(),
          '/documents': (_) => const DocumentVaultScreen(),
          '/upload': (_) => const DocumentUploadScreen(),
          '/services': (_) => const ServiceGuidanceScreen(),
          '/gr': (_) => const GRExplanationScreen(),
          '/profile': (_) => const ProfileScreen(),
          '/service/scholarship': (_) =>
              ServiceDetailScreen(serviceId: 'scholarship'),
          '/service/license': (_) => ServiceDetailScreen(serviceId: 'license'),
          '/service/income': (_) => ServiceDetailScreen(serviceId: 'income'),
        },
      ),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const DocumentVaultScreen(),
    const ServiceGuidanceScreen(),
    const GRExplanationScreen(),
    const ProfileScreen(),
  ];

  final List<BottomNavItem> _navItems = [
    BottomNavItem(icon: Icons.home, label: 'Home'),
    BottomNavItem(icon: Icons.folder, label: 'Vault'),
    BottomNavItem(icon: Icons.work, label: 'Services'),
    BottomNavItem(icon: Icons.description, label: 'GR Summary'),
    BottomNavItem(icon: Icons.person, label: 'Profile'),
  ];

  @override
  void initState() {
    super.initState();
    // Listen to voice controller for navigation commands
    WidgetsBinding.instance.addPostFrameCallback((_) {
      try {
        final voiceController =
            Provider.of<VoiceAgentController>(context, listen: false);
        voiceController.addListener(_onVoiceNavigation);
      } catch (e) {
        // Context not available
      }
    });
  }

  void _onVoiceNavigation() {
    if (!mounted) return;
    try {
      final voiceController =
          Provider.of<VoiceAgentController>(context, listen: false);
      if (voiceController.targetNavigationIndex != null) {
        setState(() {
          _currentIndex = voiceController.targetNavigationIndex!;
        });
        // Clear the navigation target after processing
        voiceController.clearNavigationTarget();
      }
    } catch (e) {
      // Context not available
    }
  }

  @override
  void dispose() {
    try {
      final voiceController =
          Provider.of<VoiceAgentController>(context, listen: false);
      voiceController.removeListener(_onVoiceNavigation);
    } catch (e) {
      // Widget is being disposed
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: NavigationBar(
          selectedIndex: _currentIndex,
          onDestinationSelected: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          destinations: _navItems.map((item) {
            final isSelected = _currentIndex == _navItems.indexOf(item);
            return NavigationDestination(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Colors.blue.withOpacity(0.1)
                      : Colors.transparent,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  item.icon,
                  color: isSelected ? Colors.blue : Colors.grey.shade600,
                ),
              ),
              label: item.label,
            );
          }).toList(),
          backgroundColor: Colors.white,
          elevation: 0,
          height: 70,
        ),
      ),
    );
  }
}

class BottomNavItem {
  final IconData icon;
  final String label;

  BottomNavItem({required this.icon, required this.label});
}
