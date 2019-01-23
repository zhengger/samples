import 'package:flutter/material.dart';
import 'package:model_shopper/models/cart.dart';
import 'package:model_shopper/provider/provider.dart';

class MyCart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart', style: Theme.of(context).textTheme.display4),
        backgroundColor: Colors.white,
      ),
      body: Container(
        color: Colors.yellow,
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: new _CartList(),
              ),
            ),
            Container(height: 4, color: Colors.black),
            _CartTotal()
          ],
        ),
      ),
    );
  }
}

class _CartList extends StatelessWidget {
  const _CartList({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Provide<CartModel>(
      builder: (context, child, cart) => ListView(
          children: cart.items
              .map((item) => Text(
                    '· ${item.name}',
                    style: Theme.of(context).textTheme.title,
                  ))
              .toList()),
    );
  }
}

class _CartTotal extends StatelessWidget {
  const _CartTotal({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Provide<CartModel>(
                builder: (context, child, cart) => Text('\$${cart.totalPrice}',
                    style: Theme.of(context)
                        .textTheme
                        .display4
                        .copyWith(fontSize: 48))),
            SizedBox(width: 24),
            FlatButton(
              onPressed: () {
                Scaffold.of(context).showSnackBar(
                    SnackBar(content: Text('Buying not supported yet.')));
              },
              color: Colors.white,
              child: Text('BUY'),
            ),
          ],
        ),
      ),
    );
  }
}
