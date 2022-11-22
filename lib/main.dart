import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopelt/src/models/orderList.dart';
import 'package:shopelt/src/pages/cartPage.dart';
import 'package:shopelt/src/pages/ordersPage.dart';
import 'package:shopelt/src/providers/productList.dart';
import 'package:shopelt/src/pages/productDetailPage.dart';
import 'package:shopelt/src/pages/productsOverview.dart';
import 'package:shopelt/src/utils/appRoutes.dart';

import 'src/models/Cart.dart';

class ShopeltApp extends StatelessWidget {
  ShopeltApp({super.key});

  ThemeData th1 = ThemeData();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ProductList(),
        ),
        ChangeNotifierProvider(
          create: (_) => Cart(),
        ),
        ChangeNotifierProvider(
          create: (_) => OrderList(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: th1.copyWith(
          canvasColor: Colors.white,
          colorScheme: th1.colorScheme.copyWith(
              primary: Colors.deepPurple.shade400,
              secondary: Colors.amber.shade800,
              tertiary: Colors.amberAccent),
          buttonTheme: th1.buttonTheme.copyWith(
            buttonColor: Colors.deepOrange,
          ),
        ),
        routes: {
          AppRoutes.home: (context) => const ProductsOverviewPage(),
          AppRoutes.productDetailPage: (ctx) => const ProductDetailPage(),
          AppRoutes.cartPage: (ctx) => const CartPage(),
          AppRoutes.orders: (ctx) => const OrdersPage(),
        },
      ),
    );
  }
}

void main() {
  runApp(ShopeltApp());
}
