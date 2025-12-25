import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/models/product_model.dart';
import 'package:shop_app/models/users.dart';

class Global_provider extends ChangeNotifier {
  List<ProductModel> products = [];
  List<ProductModel> cartItems = [];
  List<AppUser> users = [];
  AppUser? currentUser;
  int currentIdx = 0;

  bool get isLoggedIn => currentUser != null;

  double get cartTotal => cartItems.fold(
      0.0, (previousValue, element) => previousValue + (element.price ?? 0) * element.count);

  List<ProductModel> get favorites =>
      products.where((element) => element.isFavorite).toList();

  Future<List<ProductModel>> loadProducts() async {
    if (products.isNotEmpty) return products;

    // remote API ehleed avna
    try {
      final response =
          await http.get(Uri.parse('https://fakestoreapi.com/products'));
      if (response.statusCode == 200) {
        products =
            ProductModel.fromList(jsonDecode(response.body) as List<dynamic>);
        notifyListeners();
        return products;
      }
    } catch (_) {
    }

    // baraanuudaa serialchilj avna
    final res = await rootBundle.loadString('assets/products.json');
    products = ProductModel.fromList(jsonDecode(res) as List<dynamic>);
    notifyListeners();
    return products;
  }

//serialization
  Future<List<AppUser>> loadUsers() async {
    if (users.isNotEmpty) return users;
    final res = await rootBundle.loadString('assets/users.json');
    users = AppUser.fromList(jsonDecode(res) as List<dynamic>);
    notifyListeners();
    return users;
  }

  void toggleFavorite(ProductModel item) {
    item.isFavorite = !item.isFavorite;
    notifyListeners();
  }

  void addToCart(ProductModel item) {
    final existing = _findCartItem(item.id);
    if (existing != null) {
      existing.count += 1;
    } else {
      item.count = 1;
      cartItems.add(item);
    }
    notifyListeners();
  }

  void removeFromCart(ProductModel item) {
    final existing = _findCartItem(item.id);
    if (existing == null) return;
    existing.count -= 1;
    if (existing.count <= 0) {
      cartItems.remove(existing);
    }
    notifyListeners();
  }

  void clearCart() {
    cartItems.clear();
    notifyListeners();
  }

  void changeCurrentIdx(int idx) {
    currentIdx = idx;
    notifyListeners();
  }

  bool login(String username, String password) {
    try {
      final match = users.firstWhere(
        (u) => u.username == username && u.password == password,
      );
      currentUser = match;
      notifyListeners();
      return true;
    } catch (_) {
      return false;
    }
  }

  void logout() {
    currentUser = null;
    notifyListeners();
  }

  ProductModel? _findCartItem(int? id) {
    try {
      return cartItems.firstWhere((element) => element.id == id);
    } catch (_) {
      return null;
    }
  }
}