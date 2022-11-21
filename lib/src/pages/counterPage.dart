import 'package:flutter/material.dart';
import 'package:shopelt/src/models/product.dart';
import 'package:shopelt/src/providers/counter.dart';

class CounterPage extends StatefulWidget {
  const CounterPage({super.key});

  @override
  State<CounterPage> createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(CounterProvider.of(context)?.state.value.toString() ?? '0'),
        centerTitle: true,
      ),
      body: Column(children: <Widget>[
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: () {
            setState(() {
              CounterProvider.of(context)?.state.inc();
            });
          },
        )
      ]),
    );
  }
}
