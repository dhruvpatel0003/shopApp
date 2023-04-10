import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/widget/product_item.dart';

import '../providers/product.dart';
import '../providers/products.dart';

class ProductGrid extends StatelessWidget {

  final bool showFavs;
  ProductGrid(this.showFavs);


  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    final products =showFavs?productsData.favoriteItems:productsData.items;
    return GridView.builder(
      padding: const EdgeInsets.all(10.0),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10),
      itemBuilder: (ctx, index) {
        return ChangeNotifierProvider.value(
          value: products[index],//list or grid reuse the widget
          // create: (ctx)=>products[index],
          child: ProductItem(
              // products[index].id,
              // products[index].title,
              // products[index].imageUrl
          ),
        );
      },
      itemCount: products.length,
    );
  }
}
