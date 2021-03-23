import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart.dart';
import '../widgets/cart_item.dart' as ciw;
import '../providers/orders.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
      ),
      body: Column(
        children: [
          Card(
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  // SizedBox(width: 10),
                  Spacer(),
                  Chip(
                    label: Text(
                      '\$${cart.totalAmount.toStringAsFixed(2)}',
                      style: TextStyle(
                          color: Theme.of(context)
                              .primaryTextTheme
                              .headline6
                              .color),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  OrderButton(cart: cart),
                ],
              ),
            ),
          ),
          SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemBuilder: (ctx, index) => ciw.CartItem(
                id: cart.item.values.toList()[index].id,
                productId: cart.item.keys.toList()[index],
                price: cart.item.values.toList()[index].price,
                quantity: cart.item.values.toList()[index].quantity,
                title: cart.item.values.toList()[index].title,
              ),
              itemCount: cart.itemCount,
            ),
          )
        ],
      ),
    );
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key key,
    @required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return TextButton(
        child: _isLoading
            ? CircularProgressIndicator()
            : Text(
                'Order Now',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                ),
              ),
        onPressed: (widget.cart.totalAmount <= 0 || _isLoading)
            // ignore: unnecessary_statements
            ? null
            // ignore: unnecessary_statements
            : () async {
                setState(() {
                  _isLoading = true;
                });
                await Provider.of<Orders>(context, listen: false).addOrder(
                  widget.cart.item.values.toList(),
                  widget.cart.totalAmount,
                );
                setState(() {
                  _isLoading = false;
                });
                widget.cart.clearCart();
              });
  }
}
