import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/screens/edit_product_screen.dart';
import 'package:shop_app/widget/app_drawer.dart';
import 'package:shop_app/widget/user_product_item.dart';

import '../providers/products.dart';

class UserProductScreen extends StatelessWidget {

  static const routeName = '/user-products';

  const UserProductScreen({Key? key}) : super(key: key);

  Future<void> _refreshProducts(BuildContext context) async{
    await Provider.of<Products>(context,listen: false).fetchAndSetProducts(true);
  }

  @override
  Widget build(BuildContext context) {
    // final productsData = Provider.of<Products>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Your Products'),
        actions: [
          IconButton(onPressed: () {
            Navigator.of(context).pushNamed(EditProductScreen.routeName);
          }, icon: Icon(Icons.add)),
        ],
      ),
      drawer:AppDrawer() ,
      body: FutureBuilder(
        future: _refreshProducts(context),
        builder: (ctx, snapshot) => snapshot.connectionState == ConnectionState.waiting ? Center(child: CircularProgressIndicator(),): RefreshIndicator(
          onRefresh: ()=>_refreshProducts(context),
          child: Consumer<Products>(

            builder : (ctx,productsData,_)=> Padding(
              padding: EdgeInsets.all(8),
              child: ListView.builder(
                itemBuilder: (_, i) => Column(
                  children: [
                    UserProductItem(
                        productsData.items[i].id!,productsData.items[i].title, productsData.items[i].imageUrl),Divider(),
                  ],
                ),
                itemCount: productsData.items.length,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
