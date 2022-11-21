import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopelt/src/components/cartItemWidget.dart';
import 'package:shopelt/src/models/Cart.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final Cart cart = Provider.of(context);
    final cartItems = cart.items.values.toList();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Card(
            margin: const EdgeInsets.all(15),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  const Text(
                    'Total',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(width: 10),
                  Chip(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    label: Text(
                      'R\$${cart.totalAmount}',
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () => print('s'),
                    style: TextButton.styleFrom(
                        textStyle: TextStyle(
                            color: Theme.of(context).colorScheme.tertiary)),
                    child: const Text('COMPRAR'),
                  )
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (ctx, i) => CartItemWidget(cartItem: cartItems[i]),
            ),
          )
        ],
      ),
    );
  }
}