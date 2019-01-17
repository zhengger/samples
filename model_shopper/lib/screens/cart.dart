import 'package:flutter/material.dart';
import 'package:model_shopper/models/cart.dart';
import 'package:scoped_model/scoped_model.dart';

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
                child: ScopedModelDescendant<CartModel>(
                    builder: (context, child, cart) {
                  return ListView(
                      children: cart.items
                          .map((item) => Text(
                                '· ${item.name}',
                                style: Theme.of(context).textTheme.title,
                              ))
                          .toList());
                }),
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
            ScopedModelDescendant<CartModel>(
                builder: (context, _, cart) => Text('\$${cart.totalPrice}',
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
