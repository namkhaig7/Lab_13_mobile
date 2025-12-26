import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/screens/product_detail.dart';
import '../models/product_model.dart';
import '../provider/globalProvider.dart';
import '../l10n/strings.dart';

class ProductViewShop extends StatelessWidget {
  final ProductModel data;

  const ProductViewShop(this.data, {super.key});
  _onTap(BuildContext context ){
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_)=>Product_detail(data)),
    );
  }

  void _requireLogin(
      BuildContext context, Global_provider provider, VoidCallback action) {
    if (provider.isLoggedIn) {
      action();
      return;
    }
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(AppStrings.t(context, 'login')),
        content: Text(AppStrings.t(context, 'require_login')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Provider.of<Global_provider>(context, listen: false)
                  .changeCurrentIdx(3);
            },
            child: const Text('Нэвтрэх'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Global_provider>(
      builder: (context, provider, _) {
        return InkWell(
          onTap: () => _onTap(context),
          child: Card(
            elevation: 3,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                        child: AspectRatio(
                          aspectRatio: 1 / 1.05,
                          child: Image.network(
                            data.image ?? '',
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => const Center(
                              child: Icon(Icons.broken_image, size: 40),
                            ),
                            loadingBuilder: (context, child, progress) {
                              if (progress == null) return child;
                              return const Center(child: CircularProgressIndicator(strokeWidth: 2));
                            },
                          ),
                        ),
                      ),
                      Positioned(
                        top: 4,
                        right: 4,
                        child: IconButton(
                          icon: Icon(
                            data.isFavorite ? Icons.favorite : Icons.favorite_border,
                            color: data.isFavorite ? Colors.red : Colors.grey[600],
                          ),
                          onPressed: () => _requireLogin(
                            context,
                            provider,
                            () => provider.toggleFavorite(data),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data.title ?? '',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        data.category ?? '',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '\$${(data.price ?? 0).toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.green,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () => _requireLogin(
                            context,
                            provider,
                            () => provider.addToCart(data),
                          ),
                          icon: const Icon(Icons.add_shopping_cart, size: 18),
                          label: const Text('Add to cart'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}