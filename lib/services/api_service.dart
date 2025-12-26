import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/cart_model.dart';
import '../models/product_model.dart';
import '../models/users.dart';


//task1,2
class ApiService {
  ApiService({http.Client? client}) : _client = client ?? http.Client();

  static const _baseUrl = 'https://fakestoreapi.com';
  final http.Client _client;
  int? lastAuthStatusCode;
  String? lastAuthBody;

  Future<String?> login({
    required String username,
    required String password,
  }) async {
    lastAuthStatusCode = null;
    lastAuthBody = null;
    final res = await _client.post(
      Uri.parse('$_baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    );
    lastAuthStatusCode = res.statusCode;
    lastAuthBody = res.body;
    if (res.statusCode == 200 || res.statusCode == 201) {
      final data = jsonDecode(res.body) as Map<String, dynamic>;
      return data['token'] as String?;
    }
    return null;
  }

  Future<List<ProductModel>> fetchProducts() async {
    final res = await _client.get(Uri.parse('$_baseUrl/products'));
    if (res.statusCode == 200) {
      return ProductModel.fromList(jsonDecode(res.body) as List<dynamic>);
    }
    throw Exception('Failed to load products');
  }

  Future<List<AppUser>> fetchUsers() async {
    final res = await _client.get(Uri.parse('$_baseUrl/users'));
    if (res.statusCode == 200) {
      return AppUser.fromList(jsonDecode(res.body) as List<dynamic>);
    }
    throw Exception('Failed to load users');
  }

//TASK 4
  Future<List<UserCart>> fetchUserCart(int userId) async {
    final res = await _client.get(Uri.parse('$_baseUrl/carts/user/$userId'));
    if (res.statusCode == 200) {
      return UserCart.fromList(jsonDecode(res.body) as List<dynamic>);
    }
    throw Exception('Failed to load cart');
  }


//Task 3
  Future<bool> syncCart({
    required int userId,
    required List<CartProduct> products,
  }) async {
    final res = await _client.post(
      Uri.parse('$_baseUrl/carts'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'userId': userId,
        'date': DateTime.now().toIso8601String(),
        'products': products.map((e) => e.toJson()).toList(),
      }),
    );
    return res.statusCode == 200 || res.statusCode == 201;
  }
}

