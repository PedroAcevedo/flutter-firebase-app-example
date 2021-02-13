import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:test_app/src/models/product_model.dart';
import 'package:test_app/src/providers/products_providers.dart';
import 'package:test_app/src/utils/util.dart' as utils;

class ProductPage extends StatefulWidget {
  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  Product product = new Product();
  final productProvider = new ProductsProvider();
  bool _saving = false;
  File photo;

  @override
  Widget build(BuildContext context) {
    final Product prodData = ModalRoute.of(context).settings.arguments;

    if (prodData != null) {
      product = prodData;
    }

    return Scaffold(
      appBar: AppBar(
        key: scaffoldKey,
        title: Text('Product'),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.photo_size_select_actual),
              onPressed: _selectPhoto),
          IconButton(icon: Icon(Icons.camera_alt), onPressed: _takePhoto)
        ],
      ),
      body: Builder(
        builder: (context) => SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(15.0),
            child: Form(
              key: formKey,
              child: Column(
                children: <Widget>[
                  _showPhoto(),
                  _createName(),
                  _createPrice(),
                  _createAvailable(),
                  _createButton(context)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _createName() {
    return TextFormField(
      initialValue: product.title,
      decoration: InputDecoration(labelText: 'Product'),
      onSaved: (value) => product.title = value,
      validator: (value) {
        if (value.length < 3) {
          return 'The name of the product is required';
        } else {
          return null;
        }
      },
    );
  }

  Widget _createPrice() {
    return TextFormField(
      initialValue: product.value.toString(),
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(labelText: 'Price'),
      onSaved: (value) => product.value = double.parse(value),
      validator: (value) {
        if (utils.isNumeric(value)) {
          return null;
        } else {
          return 'Only number are allowed';
        }
      },
    );
  }

  Widget _createButton(BuildContext context) {
    return RaisedButton.icon(
      padding: EdgeInsets.symmetric(
        horizontal: 20.0,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      textColor: Colors.white,
      color: Colors.greenAccent,
      label: Text('save'),
      icon: Icon(Icons.save),
      onPressed: (_saving)
          ? null
          : () {
              _submit(context);
            },
    );
  }

  Widget _createAvailable() {
    return SwitchListTile(
      value: product.available,
      title: Text('Available'),
      activeColor: Colors.greenAccent,
      onChanged: (value) => setState(() {
        product.available = value;
      }),
    );
  }

  void _submit(BuildContext context) async {
    if (!formKey.currentState.validate()) return;

    formKey.currentState.save();
    setState(() {
      _saving = true;
    });

    if ( photo != null){
      product.url = await productProvider.uploadImage(photo);
    }

    if (product.id == null) {
      productProvider.createProduct(product);
    } else {
      productProvider.editProduct(product);
    }
    setState(() {
      _saving = false;
    });
    showSnackBar('Registro guardado', context);

    Navigator.pop(context);
  }

  void showSnackBar(String message, BuildContext context) {
    Scaffold.of(context).showSnackBar(
      new SnackBar(
        content: Text(message),
        duration: Duration(milliseconds: 1500),
      ),
    );
  }

  Widget _showPhoto() {
    if (product.url != null) {
      return FadeInImage(
          image: NetworkImage(product.url),
          placeholder: AssetImage('assets/jar-loading.gif'),
          height: 300.0,
          fit: BoxFit.contain,
        );
    } else {
      if (photo != null) {
        return Image.file(photo, height: 300.0, fit: BoxFit.cover);
      } else {
        return Image.asset('assets/no-image.png');
      }
    }
  }

  _selectPhoto() async {
    _processImage(ImageSource.gallery);
  }

  _takePhoto() async {
    _processImage(ImageSource.camera);
  }

  _processImage(ImageSource origin) async {
    final picked = ImagePicker();

    final pickedFile = await picked.getImage(
      source: origin,
    );

    photo = File(pickedFile.path);

    if (photo != null) {
      product.url = null;
    } else {}

    setState(() {});
  }
}
