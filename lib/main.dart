import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/auth_service.dart';
import 'services/voice_agent_controller.dart';
import 'services/document_provider.dart';
import 'screens/auth_screen.dart';
import 'screens/home_screen.dart';
import 'screens/document_vault_screen.dart';
import 'screens/service_guidance_screen.dart';
import 'screens/document_upload_screen.dart';
import 'screens/gr_explanation_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
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
              auth.isAuthenticated ? const HomeScreen() : const AuthScreen(),
        ),
        routes: {
          '/home': (_) => const HomeScreen(),
          '/documents': (_) => const DocumentVaultScreen(),
          '/upload': (_) => const DocumentUploadScreen(),
          '/services': (_) => const ServiceGuidanceScreen(),
          '/gr': (_) => const GRExplanationScreen(),
          '/service/scholarship': (_) => const ServiceDetailScreen(serviceId: 'scholarship'),
          '/service/license': (_) => const ServiceDetailScreen(serviceId: 'license'),
          '/service/income': (_) => const ServiceDetailScreen(serviceId: 'income'),
        },
      ),
    );
  }
}
