import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopelt/src/models/auth.dart';
import 'package:shopelt/src/pages/authPage.dart';
import 'package:shopelt/src/pages/productsOverview.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    Auth auth = Provider.of(context);
    return auth.isAuthenticated
        ? const ProductsOverviewPage()
        : const AuthPage();
  }
}
