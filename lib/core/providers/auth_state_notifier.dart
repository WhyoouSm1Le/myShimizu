import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shimizu_app/core/providers/auth_provider.dart';

part 'auth_state_notifier.g.dart';

@riverpod
class AuthController extends _$AuthController {
  @override
  FutureOr<void> build() {
    return null;
  }

  Future<bool> login(String email, String password) async {
    final repository = ref.read(authRepositoryProvider);
    
    state = const AsyncLoading();
    
    state = await AsyncValue.guard(
      () => repository.signInWithEmailAndPassword(email, password),
    );

    return !state.hasError;
  }

  Future<bool> register(String email, String password, String name) async {
    final repository = ref.read(authRepositoryProvider);
    
    state = const AsyncLoading();
    
    state = await AsyncValue.guard(() async {
      final credential = await repository.signUpWithEmailAndPassword(email, password);
      await credential.user?.updateDisplayName(name);
      await credential.user?.reload();
    });

    return !state.hasError;
  }

  Future<void> logout() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await FirebaseAuth.instance.signOut();
    });
  }
}