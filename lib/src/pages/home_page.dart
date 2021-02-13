import 'package:flutter/material.dart';
import 'package:test_app/src/bloc/provider_bloc.dart';
import 'package:test_app/src/models/product_model.dart';
import 'package:test_app/src/preferences/user_preferences.dart';
import 'package:test_app/src/providers/products_providers.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomePage extends StatelessWidget {
  final productsProvider = new ProductsProvider();

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of(context);
    final _prefs = UserPreference();

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).timeLine),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.logout), // The "+" icon
            onPressed: () {
              _prefs.remove("token");
              Navigator.pushReplacementNamed(context, 'login');

            }, // The `_incrementCounter` function
          ),
        ],
      ),
      body: _createList(),
      floatingActionButton: _createButtom(context),
    );
  }

  Widget _createList() {
    return FutureBuilder(
        future: productsProvider.getProducts(),
        builder: (BuildContext context, AsyncSnapshot<List<Product>> snapshot) {
          if (snapshot.hasData) {
            final products = snapshot.data;

            return ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, i) => _createWidget(context, products[i]),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }

  Widget _createWidget(BuildContext context, Product product) {
    return Dismissible(
        key: UniqueKey(),
        background: Container(
          color: Colors.red,
        ),
        onDismissed: (direction) {
          productsProvider.deleteProducts(product.id);
        },
        child: Card(
          child: Column(
            children: <Widget>[
              (product.url == null)
                  ? Image(image: AssetImage('assets/no-image.png'))
                  : FadeInImage(
                      image: NetworkImage(product.url),
                      placeholder: AssetImage('assets/jar-loading.gif'),
                      height: 300.0,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
              ListTile(
                title: Text('${product.title} - ${product.value}'),
                subtitle: Text(product.id),
                onTap: () =>
                    Navigator.pushNamed(context, 'product', arguments: product),
              )
            ],
          ),
        ));
  }

  Widget _createButtom(BuildContext context) {
    return FloatingActionButton(
      child: Icon(Icons.add),
      onPressed: () => Navigator.pushNamed(context, 'product'),
    );
  }
}
