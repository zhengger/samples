import 'package:flutter/material.dart';
import 'package:model_shopper/models/cart.dart';
import 'package:model_shopper/provider/provider.dart';
import 'package:model_shopper/screens/cart.dart';
import 'package:model_shopper/screens/catalog.dart';
import 'package:model_shopper/screens/login.dart';

void main() {
  final cart = CartModel();
  final providers = Providers()..provideValue(cart);

  // Just for fun: a stream.
  final tickStream = Stream.periodic(const Duration(seconds: 1), (n) => n);
  providers.provide(Provider.stream(tickStream));

  runApp(
    ProviderNode(
      providers: providers,
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.yellow,
        textTheme: TextTheme(
          display4: TextStyle(
            fontFamily: 'Corben',
            fontWeight: FontWeight.w700,
            fontSize: 24,
            color: Colors.black,
          ),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => MyLoginScreen(),
        '/catalog': (context) => MyCatalog(),
        '/cart': (context) => MyCart(),
      },
    );
  }
}
