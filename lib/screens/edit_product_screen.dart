import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/product.dart';
import 'package:shop_app/providers/products.dart';

//////Error in getting id 42 & Error in validation & loading progress

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-product';
  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  var _editedProduct =
      Product(id: '', title: '', description: '', price: 0, imageUrl: '');

  var _initValues = {
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': '',
  };
  var _isInit = true;
  // var _isLoading = false;

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // if (_isInit) {
    //   print("before checking");
      // final productId = ModalRoute.of(context)?.settings.arguments as String;
      // print("After checking");
      // _editedProduct =
      // Provider.of<Products>(context, listen: false).findById(productId);
      // _initValues = {
      //   'title': _editedProduct.title,
      //   'description': _editedProduct.description,
      //   'price': _editedProduct.price.toString(),
      //   'imageUrl' : ' '
      // };
      // _imageUrlController.text = _editedProduct.imageUrl;
    }
    // _isInit = false;
    // super.didChangeDependencies();


  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();
    super.dispose();
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      if ((!_imageUrlController.text.startsWith('http') &&
          !_imageUrlController.text.startsWith('https')) ||
          (!_imageUrlController.text.endsWith('.png') &&
              !_imageUrlController.text.endsWith('.jpg') &&
              !_imageUrlController.text.endsWith('.jpeg'))) {
        return;
      }
      setState(() {});
    }
    // if (!_imageUrlFocusNode.hasFocus) {
    //   setState(() {});
    // }
  }

  void _saveForm() {
    // final isValid = _form.currentState?.validate();
    // print(isValid);
    // if(isValid==null){
    //   return;
    // }
    _form.currentState?.save();
    setState(() {
      // _isLoading = true;
    });
    print("in saving mode" + _editedProduct.title);
    // if (_editedProduct.id != null) {

    //await  Provider.of<Products>(context, listen: false).updateProduct(_editedProduct.id!,_editedProduct);
    // setState(() {
    //
    //   _isLoading=false;
    // });

    // } else {
    Provider.of<Products>(context, listen: false)
        .addProduct(_editedProduct)
        .catchError((error) {
      return showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text("An error occured"),
          content: Text('Something went wrong!'),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
                child: Text('Okay'))
          ],
        ),
      );
    });
    // ?
    // .then((_) {
    //   setState(() {
    //     // _isLoading = false;
    //   });
    //   _isLoading = false;
    Navigator.of(context).pop(); //Your product page

    // });
    // }
    // Navigator.of(context).pop(); //Your product page
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: [IconButton(onPressed: _saveForm, icon: Icon(Icons.save))],
      ),
      // body: _isLoading ? Center( child: CircularProgressIndicator(),):
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _form,
          child: ListView(
            children: [
              TextFormField(
                initialValue: _initValues['title'],
                decoration: InputDecoration(labelText: 'Title'),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_priceFocusNode);
                },
                validator: (value){
                  print("inside validator$value");
                if(value!.isEmpty){
                  print(value.isEmpty);
                  return 'Please provide a value here!';
                }
                return 'done';
                // return null;
                },
                onSaved: (value) {
                  print("inside 1");
                  _editedProduct = Product(
                      title: value!,
                      price: _editedProduct.price,
                      description: _editedProduct.description,
                      imageUrl: _editedProduct.imageUrl,
                      id: _editedProduct.id,
                      isFavorite: _editedProduct.isFavorite);
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Price'),
                initialValue: _initValues['price'],
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                focusNode: _priceFocusNode,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_descriptionFocusNode);
                },
                // validator: (value){
                //  if(value.isEmpty){
                //    return 'Please enter a price';
                //  }
                //  if(double.tryParse((value != null) as String) != null ){
                //    return 'Please enter a valid number';
                //  }
                //  if(double.parse(value)<0){
                //    return 'Please enter a number greater than zero';
                //  }
                //  return null;
                // },
                onSaved: (value) {
                  _editedProduct = Product(
                      title: _editedProduct.title,
                      price: double.parse(value!),
                      description: _editedProduct.description,
                      imageUrl: _editedProduct.imageUrl,
                      id: _editedProduct.id,
                      isFavorite: _editedProduct.isFavorite);
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Description'),
                initialValue: _initValues['description'],
                maxLines: 3,
                keyboardType: TextInputType.multiline,
                focusNode: _descriptionFocusNode,
                onSaved: (value) {
                  _editedProduct = Product(
                      title: _editedProduct.title,
                      price: _editedProduct.price,
                      description: value!,
                      imageUrl: _editedProduct.imageUrl,
                      id: _editedProduct.id,
                      isFavorite: _editedProduct.isFavorite);
                },
                // validator: (value){
                //   if(value.isEmpty){
                //     return 'Please enter a description';
                //   }
                //   if(value.length <10){
                //     return 'Description should be at least 10 characters long';
                //   }
                //   return null;
                // },
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    margin: EdgeInsets.only(top: 8, right: 10),
                    decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.grey)),
                    child: _imageUrlController.text.isEmpty
                        ? Text('Enter a URL')
                        : FittedBox(
                            child: Image.network(
                              _imageUrlController.text,
                              fit: BoxFit.cover,
                            ),
                          ),
                  ),
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(labelText: 'Image URL'),
                      keyboardType: TextInputType.url,
                      textInputAction: TextInputAction.done,
                      controller: _imageUrlController,
                      focusNode: _imageUrlFocusNode,
                      onFieldSubmitted: (_) => _saveForm,
                      // validator: (value){
                      //   if(value.isEmpty){
                      //     return 'Please enter an image URL here!';
                      //   }
                      //   if(value.startsWith('http')&&!value.startsWith('https')){
                      //     return 'Enter a valid URL';
                      //   }
                      //   if(!value.endsWith('.png')&&!value.endsWith('.jpg')&&!value.endsWith('.jpeg')){
                      //     return 'Enter a valid URL';
                      //   }
                      //   return null;
                      // },
                      onSaved: (value) {
                        _editedProduct = Product(
                            title: _editedProduct.title,
                            price: _editedProduct.price,
                            description: _editedProduct.description,
                            imageUrl: value!,
                            id: _editedProduct.id,
                            isFavorite: _editedProduct.isFavorite);
                      },
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
