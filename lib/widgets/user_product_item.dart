import 'package:flutter/material.dart';
import 'package:myshop/providers/products_provider.dart';
import 'package:myshop/screens/edit_product.dart';
import 'package:provider/provider.dart';

class UserProductItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;
  UserProductItem(this.id, this.title, this.imageUrl);
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
      ),
      trailing: Container(
        width: 100,
        child: Row(
          children: [
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  EditProductScreen.routeName,
                  arguments: id,
                );
              },
              color: Theme.of(context).primaryColor,
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () => showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: Text('Are You Sure to'),
                  content: Text('Delete Product'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () async {
                        try {
                          await Provider.of<ProductsProvider>(context,
                                  listen: false)
                              .deleteProduct(id);
                        } catch (error) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Deleting Failed')));
                        }
                        Navigator.pop(context);
                      },
                      child: Text('OK'),
                    ),
                  ],
                ),
              ),
              color: Theme.of(context).errorColor,
            ),
          ],
        ),
      ),
    );
  }
}
