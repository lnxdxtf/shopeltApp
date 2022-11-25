import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopelt/src/models/Cart.dart';
import 'package:shopelt/src/models/cartItem.dart';

class CartItemWidget extends StatelessWidget {
  final CartItem cartItem;

  const CartItemWidget({
    super.key,
    required this.cartItem,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(cartItem.id),
      confirmDismiss: (_) => showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Remove Item from Cart'),
          content: Text('Item ${cartItem.title}'),
          actions: [
            TextButton(
                onPressed: () => Navigator.of(ctx).pop(true),
                child: const Text('Yes')),
            TextButton(
                onPressed: () => Navigator.of(ctx).pop(false),
                child: const Text('No')),
          ],
        ),
      ),
      onDismissed: (_) => Provider.of<Cart>(
        context,
        listen: false,
      ).removeItem(cartItem.productID),
      direction: DismissDirection.endToStart,
      background: Container(
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 10),
        color: Colors.red,
        child: const Icon(
          Icons.close_rounded,
          color: Colors.white,
          size: 40,
        ),
      ),
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: Theme.of(context).colorScheme.primary,
            child: Image.network(
              cartItem.imageUrl,
              fit: BoxFit.cover,
              alignment: Alignment.center,
            ),
          ),
          title: Text('${cartItem.title} - ${cartItem.quantity}x'),
          subtitle: Text('\$ ${cartItem.price}'),
          trailing: Text('\$ ${cartItem.quantity * cartItem.price}'),
        ),
      ),
    );
  }
}
