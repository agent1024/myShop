import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/orders.dart' show Orders;
import '../widgets/order_item.dart';
import 'package:myshop/widgets/app_drawer.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = '/orders';
  // bool isLoading = false;
  @override
  // void initState() {
  //       isLoading = true;
  //    Provider.of<Orders>(context, listen: false).fetchAndSetOrders().then((_) {
  //       setState(() {
  //       isLoading = false;
  //     });
  //    });
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    print('order screen');
    // final orderData = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
          future:
              Provider.of<Orders>(context, listen: false).fetchAndSetOrders(),
          builder: (context, dataSnapShot) {
            if (dataSnapShot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              if (dataSnapShot.error != null) {
                return Center(
                  child: Text('error'),
                );
              } else {
               return Consumer<Orders>(
                    builder: (_, orderData, __) => ListView.builder(
                          itemCount: orderData.orders.length,
                          itemBuilder: (ctx, i) =>
                              OrderItem(orderData.orders[i]),
                        ),);
              }
            }
          },),
    );
  }
}
