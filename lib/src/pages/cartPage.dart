import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopelt/src/components/cartItemWidget.dart';
import 'package:shopelt/src/providers/Cart.dart';
import 'package:shopelt/src/providers/orderList.dart';
import 'package:shopelt/src/utils/appRoutes.dart';

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
                  const SizedBox(width: 10),
                  Chip(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    label: Text(
                      '\$${cart.totalAmount.toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const Spacer(),
                  CartBuyButton(cart: cart)
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

class CartBuyButton extends StatefulWidget {
  const CartBuyButton({
    Key? key,
    required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  State<CartBuyButton> createState() => _CartBuyButtonState();
}

class _CartBuyButtonState extends State<CartBuyButton> {
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const CircularProgressIndicator()
        : TextButton(
            onPressed: widget.cart.itemsCount == 0
                ? null
                : () async {
                    setState(() => _isLoading = true);
                    await Provider.of<OrderList>(context, listen: false)
                        .addOrder(widget.cart);
                    widget.cart.clear();
                    setState(() => _isLoading = false);
                    // Navigator.of(context).pushNamed(AppRoutes.orders);
                  },
            style: TextButton.styleFrom(
                textStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.tertiary)),
            child: const Text('BUY'),
          );
  }
}
