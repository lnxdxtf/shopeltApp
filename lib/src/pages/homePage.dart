import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopelt/src/models/auth.dart';
import 'package:shopelt/src/pages/authPage.dart';
import 'package:shopelt/src/pages/productsOverview.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Auth>(context);
    return FutureBuilder(
      future: auth.autoLogin(),
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return auth.isAuthenticated ? const ProductsOverviewPage() : const AuthPage();
        }
      },
    );
  }
}
