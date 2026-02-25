// lib/viewmodels/auth_viewmodel.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user.dart';
import '../services/api_service.dart';

/// Holds authentication state: token + fetched user profile.
class AuthState {
  final String? token;
  final UserProfile? user;

  const AuthState({this.token, this.user});

  bool get isLoggedIn => token != null;

  AuthState copyWith({String? token, UserProfile? user}) => AuthState(
        token: token ?? this.token,
        user: user ?? this.user,
      );
}

/// Manages login, logout, registration, and user profile fetching.
class AuthViewModel extends AsyncNotifier<AuthState> {
  @override
  Future<AuthState> build() async => const AuthState();

  ApiService get _api => ref.read(apiServiceProvider);

  /// Login user
  Future<void> login(String username, String password) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final token = await _api.login(username, password);
      // Fetch demo user profile (user #1 for now)
      final user = await _api.getUserById(1);
      return AuthState(token: token, user: user);
    });
  }

  /// Logout user
  void logout() {
    state = const AsyncData(AuthState());
  }

  /// Register user
  ///
  /// Returns true if registration is successful, false otherwise
  Future<bool> register({
    required String firstname,
    required String lastname,
    required String username,
    required String email,
    required String phone,
    required String password,
  }) async {
    state = const AsyncLoading();
    final result = await AsyncValue.guard(() async {
      // Fakestore API doesn't actually support real registration, so we simulate it
      final token = await _api.register(
        firstname: firstname,
        lastname: lastname,
        username: username,
        email: email,
        phone: phone,
        password: password,
      );

      // After "registration", fetch demo user profile
      final user = await _api.getUserById(1);

      // Update state
      state = AsyncData(AuthState(token: token, user: user));

      return true;
    });

    if (result.hasError) {
      return false;
    }
    return result.value ?? false;
  }
}

// ---------------------------------------------------------------------------
// Providers
// ---------------------------------------------------------------------------

final apiServiceProvider = Provider<ApiService>((_) => ApiService());

final authViewModelProvider =
    AsyncNotifierProvider<AuthViewModel, AuthState>(AuthViewModel.new);
