import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/globalProvider.dart';
import '../l10n/strings.dart';

class BagsPage extends StatelessWidget {

  const BagsPage({super.key});
 
   @override
  Widget build(BuildContext context) {

      return Consumer<Global_provider>(
      builder: (context, provider, child) {
        if (provider.cartItems.isEmpty) {
          return Scaffold(
            body: Center(child: Text(AppStrings.t(context, 'cart_empty'))),
          );
        }
        return Scaffold(
          appBar: AppBar(
            title: Text(AppStrings.t(context, 'cart_title')),
          ),
          body: ListView.builder(
            itemCount: provider.cartItems.length,
            itemBuilder: (context, index) {
              final item = provider.cartItems[index];
              return Card(
                margin: const EdgeInsets.all(8.0),
                child: ListTile(
                  leading: Image.network(
                    item.image ?? '',
                    width: 64,
                    height: 64,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) =>
                        const Icon(Icons.broken_image, size: 40),
                  ),
                  title: Text(item.title ?? ''),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('\$${(item.price ?? 0).toStringAsFixed(2)}'),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove_circle_outline),
                            onPressed: () => provider.removeFromCart(item),
                          ),
                          Text('${item.count}'),
                          IconButton(
                            icon: const Icon(Icons.add_circle_outline),
                            onPressed: () => provider.addToCart(item),
                          ),
                        ],
                      ),
                    ],
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () => provider.removeFromCart(item),
                  ),
                ),
              );
            },
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${AppStrings.t(context, 'total')}: \$${provider.cartTotal.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: Text(AppStrings.t(context, 'buy_all')),
                ),
              ],
            ),
          ),
        );
      });
}
}