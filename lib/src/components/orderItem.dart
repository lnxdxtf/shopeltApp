import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shopelt/src/models/Order.dart';
import 'package:shopelt/src/utils/assetsPath.dart';

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
  final _noImage = 'https://www.tharagold.in/assets/img/no-product-found.png';
  bool _expanded = false;
  @override
  Widget build(BuildContext context) {
    final double orderExpandedHeight = (widget.orderItem.products.length * 100) + 10;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        height: _expanded ? orderExpandedHeight + 100 : 100,
        child: Card(
          child: Column(
            children: [
              ListTile(
                title: Text('Total: \$${widget.orderItem.total.toStringAsFixed(2)}'),
                subtitle: Text(DateFormat('dd/MM/yyyy hh:mm').format(widget.orderItem.date)),
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
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                height: _expanded ? orderExpandedHeight : 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                  child: ListView(
                      children: widget.orderItem.products
                          .map((product) => Card(
                                child: ListTile(
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
                                  title: Text(
                                    product.title,
                                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                  ),
                                  trailing: Text(
                                    '${product.quantity}x \$${product.price}',
                                    style: const TextStyle(color: Colors.black54),
                                  ),
                                  subtitle: Text(product.id),
                                ),
                              ))
                          .toList()),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
