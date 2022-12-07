import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopelt/src/exceptions/httpException.dart';
import 'package:shopelt/src/models/product.dart';
import 'package:shopelt/src/providers/productList.dart';
import 'package:shopelt/src/utils/appRoutes.dart';
import 'package:shopelt/src/utils/assetsPath.dart';

class ProductManagerItem extends StatelessWidget {
  final Product product;
  const ProductManagerItem({required this.product, super.key});

  @override
  Widget build(BuildContext context) {
    final messageNotify = ScaffoldMessenger.of(context);

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Theme.of(context).errorColor,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: FadeInImage(
            placeholder: const AssetImage(AssetsPath.productPlaceHolder),
            image: NetworkImage(product.imageUrl),
            fit: BoxFit.cover,
            imageErrorBuilder: (ctx, error, stackTrace) => Image.asset(AssetsPath.productPlaceHolder),
            placeholderErrorBuilder: (ctx, error, stackTrace) => Image.asset(AssetsPath.productPlaceHolder),
          ),
        ),
      ),
      title: Text(product.title),
      trailing: SizedBox(
        width: 100,
        child: Row(
          children: [
            IconButton(
              color: Theme.of(context).colorScheme.secondary,
              icon: const Icon(Icons.edit),
              onPressed: () => Navigator.of(context).pushNamed(
                AppRoutes.productsFormManage,
                arguments: product,
              ),
            ),
            IconButton(
              color: Colors.red,
              icon: const Icon(Icons.delete),
              onPressed: () => showDialog<bool>(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('Delete item'),
                  content: const Text('Are you sure ?'),
                  actions: [
                    TextButton(
                      child: const Text('Yes'),
                      onPressed: () => Navigator.of(ctx).pop(true),
                    ),
                    TextButton(
                      child: const Text('No'),
                      onPressed: () => Navigator.of(ctx).pop(false),
                    ),
                  ],
                ),
              ).then((value) async {
                if (value ?? false) {
                  try {
                    await Provider.of<ProductList>(context, listen: false).removeProduct(product);
                  } on HttpException catch (err) {
                    messageNotify.showSnackBar(SnackBar(
                      content: Text(
                        err.toString(),
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Theme.of(context).errorColor, fontSize: 18),
                      ),
                    ));
                  }
                }
              }),
            ),
          ],
        ),
      ),
    );
  }
}
