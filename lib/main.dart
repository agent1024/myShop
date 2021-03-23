import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:myshop/providers/auth.dart';
import 'package:myshop/screens/cart_screen.dart';
import 'package:myshop/screens/edit_product.dart';
import 'package:myshop/screens/splash_screen.dart';
import 'package:myshop/screens/user_products_screen.dart';
import 'package:myshop/screens/product_detail_screen.dart';
import './screens/products_overview_screen.dart';
import './providers/products_provider.dart';
import './providers/cart.dart';
import './providers/orders.dart';
import './providers/auth.dart';
import './screens/orders_screen.dart';
import './screens/auth_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, ProductsProvider>(
          create: null,
          update: (ctx, auth, previousProducts) => ProductsProvider(
            auth.token,
            auth.userId,
            previousProducts == null ? [] : previousProducts.items,
          ),
        
        ),
        ChangeNotifierProvider(
          create: (ctx) => Cart(),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          create: null,
          update: (ctx, auth, previousOrder) => Orders(
            auth.token,
            auth.userId,
            previousOrder == null ? [] : previousOrder.orders,
          ),
        )
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.purple,
            accentColor: Colors.deepOrange,
            fontFamily: 'Lato',
          ),
          home: auth.isAuth ? ProductsOverviewScreen() : FutureBuilder(future: auth.tryAutoLogin(),builder: (ctx,authResultSnapShot) => authResultSnapShot.connectionState == ConnectionState.waiting ? SplashScreen() : AuthScreen(),),
          routes: {
            ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
            CartScreen.routeName: (ctx) => CartScreen(),
            OrdersScreen.routeName: (ctx) => OrdersScreen(),
            UserProductScreen.routeName: (ctx) => UserProductScreen(),
            EditProductScreen.routeName: (ctx) => EditProductScreen(),
            ProductsOverviewScreen.routeName: (ctx) => EditProductScreen(),
          },
        ),
      ),
    );
  }
}
