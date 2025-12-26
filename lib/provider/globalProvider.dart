import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../l10n/strings.dart';
import '../models/cart_model.dart';
import '../models/product_model.dart';
import '../models/users.dart';
import '../services/api_service.dart';

class Global_provider extends ChangeNotifier {
  Global_provider() {
    _restoreState();
  }

  final ApiService _api = ApiService();
  SharedPreferences? _prefs;
  String? lastLoginError;

  List<ProductModel> products = [];
  List<ProductModel> cartItems = [];
  List<AppUser> users = [];
  AppUser? currentUser;
  int currentIdx = 0;
  String? token;
  Locale _locale = const Locale('mn');

  Locale get locale => _locale;
  List<Locale> get supportedLocales => AppStrings.supportedLocales;

  bool get isLoggedIn => currentUser != null;

  double get cartTotal => cartItems.fold(
      0.0, (previousValue, element) => previousValue + (element.price ?? 0) * element.count);

  List<ProductModel> get favorites =>
      products.where((element) => element.isFavorite).toList();


//task7
  Future<void> _restoreState() async {
    _prefs = await SharedPreferences.getInstance();
    final savedLocale = _prefs?.getString('locale');
    if (savedLocale != null) {
      _locale = Locale(savedLocale);
    }
    token = _prefs?.getString('token');
    final savedUserId = _prefs?.getInt('userId');
    if (token != null && savedUserId != null) {
      await loadUsers();
      currentUser = _findUserById(savedUserId);
      if (currentUser != null) {
        await fetchUserCart(savedUserId);
      }
    }
    notifyListeners();
  }
  
//task5
  Future<List<ProductModel>> loadProducts() async {
    if (products.isNotEmpty) return products;
    try {
      products = await _api.fetchProducts();
      notifyListeners();
      return products;
    } catch (_) {
    }
    final res = await rootBundle.loadString('assets/products.json');
    products = ProductModel.fromList(jsonDecode(res) as List<dynamic>);
    notifyListeners();
    return products;
  }

  Future<List<AppUser>> loadUsers() async {
    if (users.isNotEmpty) return users;
    try {
      users = await _api.fetchUsers();
      notifyListeners();
      return users;
    } catch (_) {
    }
    final res = await rootBundle.loadString('assets/users.json');
    users = AppUser.fromList(jsonDecode(res) as List<dynamic>);
    notifyListeners();
    return users;
  }

  void toggleFavorite(ProductModel item) {
    item.isFavorite = !item.isFavorite;
    notifyListeners();
  }


  Future<void> addToCart(ProductModel item) async {
    final existing = _findCartItem(item.id);
    if (existing != null) {
      existing.count += 1;
    } else {
      item.count = 1;
      cartItems.add(item);
    }
    notifyListeners();
    await _syncCartWithServer();
  }

  Future<void> removeFromCart(ProductModel item) async {
    final existing = _findCartItem(item.id);
    if (existing == null) return;
    existing.count -= 1;
    if (existing.count <= 0) {
      cartItems.remove(existing);
    }
    notifyListeners();
    await _syncCartWithServer();
  }

  void clearCart() {
    cartItems.clear();
    notifyListeners();
  }

  void changeCurrentIdx(int idx) {
    currentIdx = idx;
    notifyListeners();
  }

  Future<bool> login(String username, String password) async {
    try {
      lastLoginError = null;
      final newToken = await _api.login(username: username, password: password);
      await loadUsers();

      late AppUser match;
      try {
        match = users.firstWhere(
          (u) => u.username == username && u.password == password,
        );
      } catch (_) {
        lastLoginError = 'Invalid username or password';
        return false;
      }

      if (newToken == null) {
        lastLoginError = 'Server did not return token (status: ${_api.lastAuthStatusCode ?? 'unknown'}). '
            'Please check network or CORS. Body: ${_api.lastAuthBody ?? 'empty'}';
        return false;
      }

      token = newToken;
      await fetchUserCart(match.id);
      await _prefs?.setString('token', newToken);

      currentUser = match;
      await _prefs?.setInt('userId', match.id);
      notifyListeners();
      return true;
    } catch (_) {
      lastLoginError = 'Login failed. Please try again.';
      return false;
    }
  }

  void logout() {
    currentUser = null;
    token = null;
    notifyListeners();
    _prefs?.remove('token');
    _prefs?.remove('userId');
    clearCart();
  }

  ProductModel? _findCartItem(int? id) {
    try {
      return cartItems.firstWhere((element) => element.id == id);
    } catch (_) {
      return null;
    }
  }

  ProductModel? _findProduct(int? id) {
    try {
      return products.firstWhere((element) => element.id == id);
    } catch (_) {
      return null;
    }
  }

  AppUser? _findUserById(int id) {
    try {
      return users.firstWhere((element) => element.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<void> fetchUserCart(int userId) async {
    try {
      final carts = await _api.fetchUserCart(userId);
      if (carts.isEmpty) return;
      await loadProducts();
      final latest = carts.last;
      final items = <ProductModel>[];
      for (final cartProduct in latest.products) {
        final product = _findProduct(cartProduct.productId);
        if (product != null) {
          items.add(product.copyWith(count: cartProduct.quantity));
        }
      }
      cartItems = items;
      notifyListeners();
    } catch (_) {
      // ignore cart load failure
    }
  }

  Future<void> _syncCartWithServer() async {
    if (currentUser == null || token == null) return;
    final payload = cartItems
        .where((element) => element.id != null)
        .map(
          (e) => CartProduct(
            productId: e.id ?? 0,
            quantity: e.count,
          ),
        )
        .toList();
    await _api.syncCart(userId: currentUser!.id, products: payload);
  }

  Future<void> setLocale(Locale locale) async {
    if (_locale == locale) return;
    _locale = locale;
    await _prefs?.setString('locale', locale.languageCode);
    notifyListeners();
  }
}