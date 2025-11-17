// --- Core Flutter and Provider Imports ---
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// --- AWS Amplify Imports ---
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';

// --- Project-Specific Imports ---
import 'amplifyconfiguration.dart';
import 'auth/auth_wrapper.dart'; // --- MODIFIED: Import the new wrapper
import 'auth/begin_screen.dart';
import 'home/appliance_repository.dart'; // --- ADDED: Import the repository
import 'home/device control/ac_control.dart';
import 'home/device control/mqtt_service.dart'; // --- ADDED: Import the MQTT service
import 'home/foot_screen.dart';
import 'settings/profile/profile_screen.dart';
import 'settings/settings_screen.dart';
import 'settings/theme/theme.dart';
import 'settings/theme/theme_provider.dart';

/// The primary entry point for the application.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    await _configureAmplify();
    runApp(
      // --- MODIFIED: Use MultiProvider for a scalable provider setup ---
      MultiProvider(
        providers: [
          // Theme provider
          ChangeNotifierProvider(create: (_) => ThemeProvider()),
          
          // Singleton provider for the MQTT service.
          // It's created once and disposed when the app closes.
          Provider<MqttService>(
            create: (_) => MqttService()..connect(),
            dispose: (_, service) => service.disconnect(),
          ),
          
          // A provider that depends on another provider.
          // This creates ApplianceRepository using the MqttService instance.
          ChangeNotifierProxyProvider<MqttService, ApplianceRepository>(
            create: (context) => ApplianceRepository(context.read<MqttService>()),
            update: (_, mqttService, previousRepo) => ApplianceRepository(mqttService),
          ),
        ],
        child: const MyApp(),
      ),
    );
  } catch (e) {
    print('Amplify configuration failed: $e');
    runApp(ErrorScreen(error: e));
  }
}

/// A helper function to configure and initialize AWS Amplify plugins.
Future<void> _configureAmplify() async {
  try {
    final authPlugin = AmplifyAuthCognito();
    final storagePlugin = AmplifyStorageS3();
    await Amplify.addPlugins([authPlugin, storagePlugin]);
    await Amplify.configure(amplifyconfig);
    safePrint('Amplify configured successfully.');
  } on Exception catch (e) {
    safePrint('FATAL: Could not configure Amplify. App cannot start.');
    throw Exception('Failed to configure Amplify: $e');
  }
}

/// The root widget of the application.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'Smart Home App',
          debugShowCheckedModeBanner: false,

          // Theme configuration
          themeMode: themeProvider.themeMode,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          
          // --- MODIFIED: Navigation configuration ---
          // The AuthWrapper is now the entry point.
          initialRoute: '/', 
          routes: {
            '/': (context) => const AuthWrapper(), // Decides where to go first
            '/login': (context) => const BeginScreen(), // Explicit login route
            '/main': (context) => const MainScreen(), 
            '/profile': (context) => const ProfileScreen(),
            '/settings': (context) => const SettingsScreen(),
            '/ac_control': (context) => const AcControlScreen(),
          },
        );
      },
    );
  }
}

/// A simple widget to display a fatal error message when initialization fails.
class ErrorScreen extends StatelessWidget {
  final Object error;
  const ErrorScreen({super.key, required this.error});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.red[900],
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Fatal Error: Could not start the app.\n\n$error',
              style: const TextStyle(color: Colors.white, fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
