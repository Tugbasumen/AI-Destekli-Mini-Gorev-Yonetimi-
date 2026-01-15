import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:gorev_yonetimi/core/theme/app_theme.dart';
import 'package:provider/provider.dart';
import 'features/view/task_list_view.dart';
import 'features/view/login_view.dart';
import 'features/viewmodel/task_view_model.dart';
import 'features/viewmodel/auth_view_model.dart';
import 'core/services/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase'i başlat
  try {
    await Firebase.initializeApp();
    debugPrint('Firebase initialized successfully');
  } catch (e) {
    // Firebase yapılandırması eksikse uygulama çalışmaya devam eder
    // Ancak authentication çalışmayacaktır
    debugPrint('Firebase initialization error: $e');
    // Hata durumunda kullanıcıya bilgi ver
    runApp(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  const Text(
                    'Firebase Başlatma Hatası',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Firebase yapılandırması eksik veya hatalı.\nLütfen google-services.json dosyasını kontrol edin.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Hata: $e',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 12, color: Colors.red),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
    return;
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
        ChangeNotifierProvider(create: (_) => TaskViewModel()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'AI Task Manager',
        theme: AppTheme.lightTheme,
        home: const AuthWrapper(),
      ),
    );
  }
}

/// Auth state'e göre yönlendirme yapan widget
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();

    return StreamBuilder(
      stream: authService.authStateChanges,
      builder: (context, snapshot) {
        // Firebase başlatılmamışsa veya hata varsa login sayfasına yönlendir
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // Kullanıcı giriş yapmışsa ana sayfaya, yoksa login sayfasına yönlendir
        if (snapshot.hasData && snapshot.data != null) {
          return const TaskListView();
        } else {
          return const LoginView();
        }
      },
    );
  }
}
