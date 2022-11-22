import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopelt/src/components/productGridItem.dart';
import 'package:shopelt/src/models/product.dart';
import 'package:shopelt/src/providers/productList.dart';

class ProductGrid extends StatelessWidget {
  final bool showOnlyFavorite;

  ProductGrid(this.showOnlyFavorite, {super.key});

  @override
  Widget build(BuildContext context) {
    final providerProductList = Provider.of<ProductList>(context);
    final List<Product> loadedProducts = showOnlyFavorite
        ? providerProductList.favItems
        : providerProductList.items;
    if (showOnlyFavorite && providerProductList.favItems.length == 0) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[
            Icon(Icons.favorite_outline_outlined),
            Text('No Favorites')
          ],
        ),
      );
    } else {
      return GridView.builder(
        padding: const EdgeInsets.all(10.0),
        itemCount: loadedProducts.length,
        itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
          value: loadedProducts[i],
          child: const ProductGridItem(),
        ),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
      );
    }
  }
}
