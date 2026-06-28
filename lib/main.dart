import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimizu_app/core/providers/auth_state_notifier.dart';
import 'package:shimizu_app/features/main/main_wrapper.dart';
import 'package:shimizu_app/features/screens/auth/login_page.dart';
import 'package:shimizu_app/firebase_options.dart';
import 'package:shimizu_app/widgets/constants/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  
  runApp(const ProviderScope(child: ShimizuApp()));
}

class ShimizuApp extends ConsumerWidget {
  const ShimizuApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authControllerProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SHIMIZU APP',
      home:  authState.when(
        data: (_) {
          final currentUser = FirebaseAuth.instance.currentUser;

          if (currentUser != null) {
            return const MainWrapper();
          }
          return const LoginPage();
        },  
        loading: () => const Scaffold(
          body: Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.greenPrimary),
            ),
          ),
        ),
        error: (err, stack) => Scaffold(
          body: Center(
            child: Text('ERROR: $err'),
          ),
        )
      ),
    );
  }
}


