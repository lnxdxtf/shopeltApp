import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopelt/src/pages/cartPage.dart';
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
        )
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
        home: const ProductsOverviewPage(),
        routes: {
          AppRoutes.productDetailPage: (ctx) => const ProductDetailPage(),
          AppRoutes.cartPage: (ctx) => const CartPage()
        },
      ),
    );
  }
}

void main() {
  runApp(ShopeltApp());
}
