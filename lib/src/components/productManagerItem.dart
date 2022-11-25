import 'package:flutter/material.dart';
import 'package:shopelt/src/models/product.dart';

class ProductManagerItem extends StatelessWidget {
  final Product product;
  const ProductManagerItem({required this.product, super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(product.imageUrl),
      ),
      title: Text(product.title),
      trailing: Container(
        width: 100,
        child: Row(
          children: [
            IconButton(
              color: Theme.of(context).colorScheme.secondary,
              icon: const Icon(Icons.edit),
              onPressed: () {},
            ),
            IconButton(
              color: Colors.red,
              icon: const Icon(Icons.delete),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
