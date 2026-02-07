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
import 'package:flutter/foundation.dart' show kIsWeb;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  if (!kIsWeb) {
    try {
      await Firebase.initializeApp();
      print('Firebase initialized successfully');
    } catch (e) {
      print('Firebase initialization failed: $e');
    }
  } else {
    print('Running in web mode (demo mode)');
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
        ChangeNotifierProvider(create: (_) => DocumentProvider()),
        ChangeNotifierProvider(create: (_) => VoiceAgentController(navigatorKey)),
      ],
      child: MaterialApp(
        title: 'SevaSetu',
        navigatorKey: navigatorKey,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
          appBarTheme: const AppBarTheme(centerTitle: true),
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
          '/service/scholarship': (_) => ServiceDetailScreen(serviceId: 'scholarship'),
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
        final voiceController = Provider.of<VoiceAgentController>(context, listen: false);
        voiceController.addListener(_onVoiceNavigation);
      } catch (e) {
        // Context not available
      }
    });
  }

  void _onVoiceNavigation() {
    if (!mounted) return;
    try {
      final voiceController = Provider.of<VoiceAgentController>(context, listen: false);
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
      final voiceController = Provider.of<VoiceAgentController>(context, listen: false);
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
                  color: isSelected ? Colors.blue.withOpacity(0.1) : Colors.transparent,
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
