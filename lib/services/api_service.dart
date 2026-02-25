// lib/services/api_service.dart

import 'dart:math';
import 'package:dio/dio.dart';
import '../models/product.dart';
import '../models/user.dart';

class ApiService {
  final Dio _dio;
  static final _random = Random();

  ApiService()
      : _dio = Dio(
          BaseOptions(
            baseUrl: 'https://fakestoreapi.com',
            connectTimeout: const Duration(seconds: 15),
            receiveTimeout: const Duration(seconds: 15),
            headers: {'Content-Type': 'application/json'},
          ),
        );

  /// Authenticate user and return JWT token.
  Future<String> login(String username, String password) async {
    try {
      final response = await _dio.post(
        '/auth/login',
        data: {'username': username, 'password': password},
      );
      return response.data['token'] as String;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Simulate user registration and return fake token.
  Future<String> register({
    required String firstname,
    required String lastname,
    required String username,
    required String email,
    required String phone,
    required String password,
  }) async {
    // FakeStore API doesn't have a real registration endpoint.
    await Future.delayed(const Duration(seconds: 1));

    // Return a fake token for demo purposes
    final fakeToken = 'fake_token_${_random.nextInt(999999)}';
    return fakeToken;
  }

  /// Fetch all products from FakeStore.
  Future<List<Product>> getProducts() async {
    try {
      final response = await _dio.get('/products');
      return (response.data as List)
          .map((e) => Product.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Fetch products filtered by category.
  Future<List<Product>> getProductsByCategory(String category) async {
    try {
      final response = await _dio.get('/products/category/$category');
      return (response.data as List)
          .map((e) => Product.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Fetch a user profile by ID.
  Future<UserProfile> getUserById(int id) async {
    try {
      final response = await _dio.get('/users/$id');
      return UserProfile.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Exception _handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
        return Exception('Connection timed out. Please check your internet.');
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        if (statusCode == 401)
          return Exception('Invalid username or password.');
        return Exception('Server error ($statusCode). Please try again.');
      case DioExceptionType.connectionError:
        return Exception('No internet connection.');
      default:
        return Exception('Unexpected error: ${e.message}');
    }
  }
}
