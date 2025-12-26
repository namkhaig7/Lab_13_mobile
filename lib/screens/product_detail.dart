import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/models/product_model.dart';
import 'package:shop_app/provider/globalProvider.dart';
import '../l10n/strings.dart';

class Product_detail extends StatelessWidget {
  final ProductModel product; 
  const Product_detail(this.product, {super.key});

  void _requireLogin(
      BuildContext context, Global_provider provider, VoidCallback action) {
    if (provider.isLoggedIn) {
      action();
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppStrings.t(context, 'require_login'))),
    );
    provider.changeCurrentIdx(3);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Global_provider>(
      builder: (context, provider, child) { 
        return Scaffold(
          appBar: AppBar(
            title: Text(product.title ?? ''),
            actions: [
              IconButton(
                icon: Icon(
                  product.isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: product.isFavorite ? Colors.red : null,
                ),
                onPressed: () => _requireLogin(
                  context,
                  provider,
                  () => provider.toggleFavorite(product),
                ),
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      product.image ?? '',
                      height: 260,
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) => const Icon(Icons.broken_image, size: 80),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  product.title ?? '',
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  product.description ?? '',
                  style: const TextStyle(fontSize: 16, height: 1.4),
                ),
                const SizedBox(height: 12),
                Text(
                  'PRICE: \$${(product.price ?? 0).toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () => _requireLogin(
              context,
              provider,
              () => provider.addToCart(product),
            ),
            icon: const Icon(Icons.shopping_cart),
            label: const Text('Add to cart'),
          ),
        );
          }
        );
  }
}