import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopelt/src/components/appDrawer.dart';
import 'package:shopelt/src/components/badgeCart.dart';
import 'package:shopelt/src/components/productGrid.dart';
import 'package:shopelt/src/models/Cart.dart';
import 'package:shopelt/src/utils/appRoutes.dart';

enum FilterMoreOptions {
  Favorite,
  All,
}

class ProductsOverviewPage extends StatefulWidget {
  const ProductsOverviewPage({super.key});

  @override
  State<ProductsOverviewPage> createState() => _ProductsOverviewPageState();
}

class _ProductsOverviewPageState extends State<ProductsOverviewPage> {
  bool _showOnlyFavorite = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Consumer<Cart>(
            builder: (ctx, cart, child) => BadgeCart(
              value: cart.itemsCount.toString(),
              color: Colors.redAccent,
              child: IconButton(
                onPressed: () =>
                    Navigator.of(context).pushNamed(AppRoutes.cartPage),
                icon: const Icon(Icons.shopping_cart),
              ),
            ),
          ),
          PopupMenuButton(
            icon: const Icon(Icons.more_vert_sharp),
            onSelected: (FilterMoreOptions filterSelected) => setState(() {
              _showOnlyFavorite =
                  filterSelected == FilterMoreOptions.Favorite ? true : false;
            }),
            itemBuilder: (_) => [
              const PopupMenuItem(
                value: FilterMoreOptions.Favorite,
                child: Text('Only Favorites'),
              ),
              const PopupMenuItem(
                value: FilterMoreOptions.All,
                child: Text('All'),
              ),
            ],
          ),
        ],
        title: const Text('Shopelt'),
        centerTitle: true,
      ),
      body: ProductGrid(_showOnlyFavorite),
      drawer: const AppDrawer(),
    );
  }
}
