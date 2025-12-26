import 'package:flutter/material.dart';

class AppStrings {
  static const supportedLocales = [Locale('en'), Locale('mn')];

  static const Map<String, Map<String, String>> _values = {
    'en': {
      'shop': 'Shop',
      'bag': 'Bag',
      'favorite': 'Favorite',
      'profile': 'Profile',
      'products_title': 'Products',
      'cart_empty': 'Cart is empty',
      'cart_title': 'Cart',
      'total': 'Total',
      'buy_all': 'Buy All',
      'login': 'Login',
      'login_hint': 'Enter your username and password',
      'username': 'Username',
      'password': 'Password',
      'login_button': 'Sign In',
      'logout': 'Logout',
      'login_error': 'Wrong username or password',
      'require_login': 'Please login first.',
      'favorites_empty': 'No favorites yet.',
      'favorites_title': 'Favorites',
      'language': 'Language',
      'language_desc': 'App language',
    },
    'mn': {
      'shop': 'Дэлгүүр',
      'bag': 'Сагс',
      'favorite': 'Таалагдсан',
      'profile': 'Профайл',
      'products_title': 'Бараанууд',
      'cart_empty': 'Сагс хоосон байна',
      'cart_title': 'Сагс',
      'total': 'Нийт',
      'buy_all': 'Бүгдийг авах',
      'login': 'Нэвтрэх',
      'login_hint': 'Нэвтрэх нэр, нууц үгээ оруулна уу',
      'username': 'Нэвтрэх нэр',
      'password': 'Нууц үг',
      'login_button': 'Нэвтрэх',
      'logout': 'Гарах',
      'login_error': 'Нэвтрэх нэр эсвэл нууц үг буруу',
      'require_login': 'Эхлээд нэвтэрнэ үү.',
      'favorites_empty': 'Таалагдсан бараа алга.',
      'favorites_title': 'Таалагдсан бараанууд',
      'language': 'Хэл',
      'language_desc': 'Апп-ын хэл',
    },
  };

  static String t(BuildContext context, String key) {
    final code = Localizations.localeOf(context).languageCode;
    return _values[code]?[key] ?? _values['en']?[key] ?? key;
  }
}

