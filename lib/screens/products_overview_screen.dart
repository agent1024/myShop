import 'package:flutter/material.dart';
import 'package:myshop/providers/products_provider.dart';
import 'package:myshop/screens/cart_screen.dart';
import 'package:myshop/widgets/app_drawer.dart';
import 'package:provider/provider.dart';
// import 'package:provider/provider.dart';
// import '../providers/products_provider.dart';
import '../providers/cart.dart';
import '../widgets/products_grid.dart';
import '../widgets/badge.dart';

enum FilterOption {
  Favorite,
  All,
}

class ProductsOverviewScreen extends StatefulWidget {
  static const routeName = '/product-overview';
  // final List<Product> loadedProduct = ;
  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  var _showOnlyFavoriteData = false;
  var _isinit = true;
  var _isLoading = false;
  // var noProducts = false;

  // @override
  // void initState() {
  //     Provider.of<ProductsProvider>(context, listen: false).fetchAndSetProducts();

  //   Future.delayed(Duration.zero).then((_) =>
  //       Provider.of<ProductsProvider>(context, listen: false)
  //           .fetchAndSetProducts());
  //   super.initState();
  // }

  @override
  void didChangeDependencies() {
    if (_isinit) {
      setState(() {
        _isLoading = true;
      });
      // final product = Provider.of<ProductsProvider>(context);
      // if (product.items.isEmpty) noProducts = true;
      Provider.of<ProductsProvider>(context)
          .fetchAndSetProducts()
          .then((value) => _isLoading = false);
      // print(noProducts);
    }
    setState(() {
      _isinit = false;
      // print(noProducts);
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    // print(noProducts);
    // final productContainer =
    // Provider.of<ProductsProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text('MyShop'),
        actions: [
          PopupMenuButton(
            onSelected: (FilterOption selcetedVal) {
              setState(() {
                if (selcetedVal == FilterOption.Favorite) {
                  // productContainer.showFavoritesOnly();
                  _showOnlyFavoriteData = true;
                } else {
                  // productContainer.showAll();
                  _showOnlyFavoriteData = false;
                }
              });
            },
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text(
                  'Only Favorite',
                ),
                value: FilterOption.Favorite,
              ),
              PopupMenuItem(
                child: Text(
                  'Show All',
                ),
                value: FilterOption.All,
              )
            ],
            icon: Icon(
              Icons.more_vert,
            ),
          ),
          Consumer<Cart>(
            builder: (_, cartData, ch) => Badge(
              child: ch,
              value: cartData.itemCount.toString(),
            ),
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.pushNamed(context, CartScreen.routeName);
              },
            ),
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: _isLoading
          ? Center(
              child:
                  // noProducts
                  //     ?
                  // Text('No Products Available') :
                  CircularProgressIndicator(),
            )
          : ProductsGrid(_showOnlyFavoriteData),
    );
  }
}
