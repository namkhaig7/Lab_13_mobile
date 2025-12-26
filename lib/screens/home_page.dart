import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/globalProvider.dart';
import '../l10n/strings.dart';
import 'bags_page.dart';
import 'shop_page.dart';
import 'favorite_page.dart';
import 'profile_page.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});
  
final List<Widget> pages = [const ShopPage(), const BagsPage(),const FavoritePage(), const ProfilePage()];
  @override
  Widget build(BuildContext context) {
    return Consumer<Global_provider>(
      builder: (context, provider, child) {
        return Scaffold(
      body: pages[provider.currentIdx],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex:provider.currentIdx,
        onTap: provider.changeCurrentIdx,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.shop),
            label: AppStrings.t(context, 'shop')),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_basket),
            label: AppStrings.t(context, 'bag')),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: AppStrings.t(context, 'favorite')),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: AppStrings.t(context, 'profile')),
        ]),
    );
  });
}}

  

