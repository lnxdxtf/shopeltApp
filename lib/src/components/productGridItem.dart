import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shopelt/src/models/auth.dart';
import 'package:shopelt/src/providers/Cart.dart';
import 'package:shopelt/src/models/product.dart';
import 'package:shopelt/src/utils/appRoutes.dart';
import 'package:shopelt/src/utils/assetsPath.dart';

class ProductGridItem extends StatelessWidget {
  const ProductGridItem({super.key});

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    final auth = Provider.of<Auth>(context, listen: false);

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        header: Container(
          padding: const EdgeInsets.all(3),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2),
                  color: Colors.black26,
                ),
                child: Text(
                  '\$${product.price.toStringAsFixed(2)}',
                  textAlign: TextAlign.end,
                  style: const TextStyle(
                    color: Colors.redAccent,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
        footer: GridTileBar(
          title: Text(
            product.title,
            style: GoogleFonts.lato(fontWeight: FontWeight.bold, fontSize: 12),
            textAlign: TextAlign.center,
          ),
          backgroundColor: Colors.black26,
          //Consumer used to notify listeners on state class
          leading: Consumer<Product>(
            builder: (ctx, product, _) => IconButton(
              iconSize: 18,
              onPressed: () => product.toggleFav(auth.token ?? '', auth.uid ?? ''),
              icon: product.isFav ? const Icon(Icons.favorite) : const Icon(Icons.favorite_border),
              color: Colors.redAccent,
            ),
          ),
          trailing: IconButton(
            iconSize: 18,
            onPressed: () {
              cart.addItem(product);
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('Produto ${product.title} adicionado'),
                duration: const Duration(seconds: 3),
                action: SnackBarAction(
                  label: 'undo',
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
          child: Hero(
            tag: product.id,
            child: FadeInImage(
              placeholder: const AssetImage(AssetsPath.productPlaceHolder),
              image: NetworkImage(product.imageUrl),
              fit: BoxFit.cover,
              imageErrorBuilder: (ctx, error, stackTrace) => Image.asset(AssetsPath.productPlaceHolder),
              placeholderErrorBuilder: (ctx, error, stackTrace) => Image.asset(AssetsPath.productPlaceHolder),
            ),
          ),
        ),
      ),
    );
  }
}
