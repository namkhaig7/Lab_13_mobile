import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/globalProvider.dart';
import '../widgets/ProductView.dart';

class FavoritePage extends StatelessWidget {
  const FavoritePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<Global_provider>(
      builder: (context, provider, child) {
        if (provider.favorites.isEmpty) {
          return const Center(child: Text('Таалагдсан бараа хараахан байхгүй байна.'));
        }
        return LayoutBuilder(
          builder: (context, constraints) {
            final crossAxisCount =
                (constraints.maxWidth / 180).floor().clamp(2, 6);
            return Padding(
              padding: const EdgeInsets.all(12.0),
              child: CustomScrollView(
                slivers: [
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Text(
                        'Таалагдсан бараанууд',
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  SliverGrid.builder(
                    itemCount: provider.favorites.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.7,
                    ),
                    itemBuilder: (_, index) =>
                        ProductViewShop(provider.favorites[index]),
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }
}