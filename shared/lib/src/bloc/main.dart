import 'package:flutter/material.dart';
import 'package:reactive_exploration/common/models/catalog.dart';
import 'package:reactive_exploration/common/widgets/cart_button.dart';
import 'package:reactive_exploration/common/widgets/product_square.dart';
import 'package:reactive_exploration/common/widgets/theme.dart';
import 'package:reactive_exploration/src/bloc/bloc_cart_page.dart';
import 'package:reactive_exploration/src/bloc/cart_bloc.dart';
import 'package:reactive_exploration/src/bloc/cart_provider.dart';

void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new CartProvider(
      child: new MaterialApp(
        title: 'Bloc',
        theme: appTheme,
        home: new MyHomePage(),
        routes: <String, WidgetBuilder>{
          BlocCartPage.routeName: (context) => new BlocCartPage()
        },
      ),
    );
  }
}

/// The sample app's main page
class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cartBloc = CartProvider.of(context);
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Bloc"),
        actions: <Widget>[
          new StreamBuilder<int>(
            stream: cartBloc.itemCount.stream,
            initialData: 0,
            builder: (context, snapshot) => new CartButton(
                  itemCount: snapshot.data,
                  onPressed: () {
                    Navigator.of(context).pushNamed(BlocCartPage.routeName);
                  },
                ),
          )
        ],
      ),
      body: new ProductGrid(),
    );
  }
}

/// Displays a tappable grid of products
class ProductGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cartBloc = CartProvider.of(context);
    return new GridView.count(
      crossAxisCount: 2,
      children: catalog.products.map((product) {
        return new ProductSquare(
          product: product,
          onTap: () {
            cartBloc.cartAddition.add(new CartAddition(product));
          },
        );
      }).toList(),
    );
  }
}
