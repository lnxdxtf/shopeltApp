import 'package:flutter/material.dart';
import 'package:shopelt/src/models/product.dart';
import 'package:shopelt/src/utils/assetsPath.dart';

class ProductDetailPage extends StatelessWidget {
  const ProductDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final Product product = ModalRoute.of(context)!.settings.arguments as Product;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
                title: Text(product.title),
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    Hero(
                      tag: product.id,
                      child: FadeInImage(
                        placeholder: const AssetImage(AssetsPath.productPlaceHolder),
                        image: NetworkImage(product.imageUrl),
                        fit: BoxFit.cover,
                        imageErrorBuilder: (ctx, error, stackTrace) => Image.asset(AssetsPath.productPlaceHolder),
                        placeholderErrorBuilder: (ctx, error, stackTrace) => Image.asset(AssetsPath.productPlaceHolder),
                      ),
                    ),
                    const DecoratedBox(
                        decoration: BoxDecoration(
                            gradient: LinearGradient(begin: Alignment(0, 0.8), end: Alignment(0, 0), colors: [
                      Color.fromRGBO(0, 0, 0, 0.6),
                      Color.fromRGBO(0, 0, 0, 0),
                    ])))
                  ],
                )),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        product.title,
                        style: const TextStyle(color: Colors.black54, fontSize: 20),
                      ),
                      Text(
                        '\$${product.price}',
                        style: const TextStyle(color: Colors.black54, fontSize: 20),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                  child: Text(product.description),
                ),
                const SizedBox(height: 700)
              ],
            ),
          )
        ],
      ),
    );
  }
}
