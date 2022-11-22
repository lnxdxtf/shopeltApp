import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shopelt/src/models/Cart.dart';
import 'package:shopelt/src/models/product.dart';
import 'package:shopelt/src/utils/appRoutes.dart';

class ProductGridItem extends StatelessWidget {
  const ProductGridItem({super.key});

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        header: Container(
          padding: const EdgeInsets.all(10),
          child: Text(
            product.price.toString(),
            textAlign: TextAlign.end,
            style: const TextStyle(
              color: Colors.redAccent,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        footer: GridTileBar(
          title: Text(
            product.title,
            style: GoogleFonts.lato(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          backgroundColor: Colors.black54,
          //Consumer used to notify listeners on state class
          leading: Consumer<Product>(
            builder: (ctx, product, _) => IconButton(
              onPressed: product.toggleFav,
              icon: product.isFav
                  ? const Icon(Icons.favorite)
                  : const Icon(Icons.favorite_border),
              color: Colors.redAccent,
            ),
          ),
          trailing: IconButton(
            onPressed: () {
              cart.addItem(product);
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('Produto ${product.title} adicionado'),
                duration: const Duration(seconds: 3),
                action: SnackBarAction(
                  label: 'DESFAZER',
                  onPressed: () => cart.removeSingleItem(product.id),
                ),
              ));
            },
            icon: const Icon(Icons.shopping_cart),
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
        child: GestureDetector(
          onTap: () => Navigator.of(context).pushNamed(
            AppRoutes.productDetailPage,
            arguments: product,
          ),
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
