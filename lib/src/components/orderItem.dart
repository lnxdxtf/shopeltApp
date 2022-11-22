import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shopelt/src/models/Order.dart';

class OrderItem extends StatefulWidget {
  final Order orderItem;
  const OrderItem({
    required this.orderItem,
    super.key,
  });

  @override
  State<OrderItem> createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  bool _expanded = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: Column(
          children: [
            ListTile(
              title: Text(
                  'Total: R\$${widget.orderItem.total.toStringAsFixed(2)}'),
              subtitle: Text(
                  DateFormat('dd/MM/yyyy hh:mm').format(widget.orderItem.date)),
              trailing: IconButton(
                icon: const Icon(Icons.expand_more),
                onPressed: () {
                  setState(() {
                    _expanded = !_expanded;
                  });
                },
              ),
              // leading: ,
            ),
            if (_expanded)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                height: 200,
                child: ListView(
                    children: widget.orderItem.products
                        .map((product) => Card(
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: Colors.white,
                                  child: Image.network(
                                    product.imageUrl,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                title: Text(
                                  product.title,
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                trailing: Text(
                                  '${product.quantity}x R\$${product.price}',
                                  style: const TextStyle(color: Colors.black54),
                                ),
                                subtitle: Text(product.id),
                              ),
                            ))
                        .toList()),
              )
          ],
        ),
      ),
    );
  }
}
