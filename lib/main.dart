import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopelt/src/models/auth.dart';
import 'package:shopelt/src/pages/authPage.dart';
import 'package:shopelt/src/pages/homePage.dart';
import 'package:shopelt/src/providers/orderList.dart';
import 'package:shopelt/src/pages/cartPage.dart';
import 'package:shopelt/src/pages/ordersPage.dart';
import 'package:shopelt/src/pages/productFormManagerPage.dart';
import 'package:shopelt/src/pages/productManagerPage.dart';
import 'package:shopelt/src/providers/productList.dart';
import 'package:shopelt/src/pages/productDetailPage.dart';
import 'package:shopelt/src/utils/appRoutes.dart';
import 'package:shopelt/src/utils/customRoute.dart';
import 'src/providers/Cart.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ShopeltApp extends StatelessWidget {
  ShopeltApp({super.key});

  ThemeData th1 = ThemeData();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, ProductList>(
          create: (_) => ProductList(),
          update: (ctx, auth, previous) => ProductList(
            auth.token ?? '',
            auth.uid ?? '',
            previous?.items ?? [],
          ),
        ),
        ChangeNotifierProxyProvider<Auth, OrderList>(
          create: (_) => OrderList(),
          update: (ctx, auth, previous) => OrderList(
            auth.token ?? '',
            auth.uid ?? '',
            previous?.items ?? [],
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => Cart(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: th1.copyWith(
            canvasColor: Colors.white,
            colorScheme: th1.colorScheme.copyWith(primary: Colors.purple.shade500, secondary: Colors.amber.shade800, tertiary: Colors.orangeAccent),
            buttonTheme: th1.buttonTheme.copyWith(
              buttonColor: Colors.deepOrange,
            ),
            pageTransitionsTheme: PageTransitionsTheme(builders: {
              TargetPlatform.android: CustomPageTransitionBuilder(),
            })),
        routes: {
          AppRoutes.home: (context) => const HomePage(),
          AppRoutes.productDetailPage: (ctx) => const ProductDetailPage(),
          AppRoutes.cartPage: (ctx) => const CartPage(),
          AppRoutes.orders: (ctx) => const OrdersPage(),
          AppRoutes.productsManage: (ctx) => const ProductManagerPage(),
          AppRoutes.productsFormManage: (ctx) => const ProductFormManagerPage(),
        },
      ),
    );
  }
}

void main() async {
  await dotenv.load(fileName: ".env");
  runApp(ShopeltApp());
}
