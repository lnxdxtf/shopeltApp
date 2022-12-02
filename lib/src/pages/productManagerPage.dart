import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopelt/src/components/appDrawer.dart';
import 'package:shopelt/src/components/productManagerItem.dart';
import 'package:shopelt/src/providers/productList.dart';
import 'package:shopelt/src/utils/appRoutes.dart';

class ProductManagerPage extends StatelessWidget {
  const ProductManagerPage({super.key});

  Future<void> _refreshProducts(BuildContext context) {
    return Provider.of<ProductList>(context, listen: false).loadProducts();
  }

  @override
  Widget build(BuildContext context) {
    final ProductList products = Provider.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Manager'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () =>
                Navigator.of(context).pushNamed(AppRoutes.productsFormManage),
          )
        ],
      ),
      drawer: const AppDrawer(),
      body: RefreshIndicator(
        onRefresh: () => _refreshProducts(context),
        child: Container(
          padding: const EdgeInsets.all(8),
          child: ListView.builder(
              itemCount: products.itemsCount,
              itemBuilder: (ctx, i) => Column(
                    children: [
                      ProductManagerItem(product: products.items[i]),
                      const Divider()
                    ],
                  )),
        ),
      ),
    );
  }
}
