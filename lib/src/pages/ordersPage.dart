import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopelt/src/components/appDrawer.dart';
import 'package:shopelt/src/components/orderItem.dart';
import 'package:shopelt/src/providers/orderList.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  Future<void> _refreshOrders(BuildContext context) async {
    await Provider.of<OrderList>(context, listen: false).loadOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Orders'),
          centerTitle: true,
        ),
        drawer: const AppDrawer(),
        body: FutureBuilder(
          future: Provider.of<OrderList>(context, listen: false).loadOrders(),
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else {
              return RefreshIndicator(
                onRefresh: () => _refreshOrders(context),
                child: Consumer<OrderList>(
                  builder: (ctx, orders, child) {
                    if (orders.itemsCount == 0) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.bug_report),
                            Text(
                              'No Orders',
                              textAlign: TextAlign.center,
                            )
                          ],
                        ),
                      );
                    } else {
                      return ListView.builder(
                        itemCount: orders.itemsCount,
                        itemBuilder: (ctx, i) =>
                            OrderItem(orderItem: orders.items[i]),
                      );
                    }
                  },
                ),
              );
            }
          },
        )
        // _isLoading
        //     ? const Center(child: CircularProgressIndicator())
        //     : orders.itemsCount == 0
        //         ? Center(
        //             child: Column(
        //               mainAxisAlignment: MainAxisAlignment.center,
        //               children: const [
        //                 Icon(Icons.bug_report),
        //                 Text(
        //                   'No Orders',
        //                   textAlign: TextAlign.center,
        //                 )
        //               ],
        //             ),
        //           )
        //         : RefreshIndicator(
        //             onRefresh: () => _refreshOrders(context),
        //             child: ListView.builder(
        //               itemCount: orders.itemsCount,
        //               itemBuilder: (ctx, i) =>
        //                   OrderItem(orderItem: orders.items[i]),
        //             ),
        //           ),
        );
  }
}
