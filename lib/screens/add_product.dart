import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/product.dart';
import 'package:shop/providers/product_providers.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});
  static String routeName = "/add_product";
  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _imageController = TextEditingController();
  final _imageFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  var _product =
      Product(id: '', title: '', description: '', imageUrl: '', price: 0);
  var _isInit = true;
  var _isLoading = false;
  @override
  void initState() {
    _imageFocusNode.addListener(_updateImageFocusNode);
    super.initState();
  }

  @override
  void dispose() {
    _imageFocusNode.removeListener(_updateImageFocusNode);
    _imageController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final productId = ModalRoute.of(context)?.settings.arguments;
      if (productId != null) {
        _product = Provider.of<Products>(context).findById(productId as String);
        _imageController.text = _product.imageUrl;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  void _updateImageFocusNode() {
    if ((!_imageController.text.startsWith("https") &&
            !_imageController.text.startsWith("http")) ||
        (!_imageController.text.endsWith(".png") &&
            !_imageController.text.endsWith(".jpg") &&
            !_imageController.text.endsWith(".jpeg"))) return;

    if (!_imageFocusNode.hasFocus) {
      setState(() {});
    }
  }

  Future<void> _saveForm() async {
    if (!_form.currentState!.validate()) return;
    _form.currentState?.save();
    setState(() {
      _isLoading = true;
    });

    if (_product.id.isNotEmpty) {
      try {
        await Provider.of<Products>(context, listen: false)
            .editProduct(_product);
      } catch (error) {
        await showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: const Text("An error occurred"),
                  content: const Text("Something went wrong"),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.of(ctx).pop();
                        },
                        child: const Text("Ok")),
                  ],
                ));
      }
    } else {
      try {
        await Provider.of<Products>(context, listen: false)
            .addProduct(_product);
      } catch (error) {
        await showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: const Text("An error occurred"),
                  content: const Text("Something went wrong"),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.of(ctx).pop();
                        },
                        child: const Text("Ok")),
                  ],
                ));
      }
    }
    setState(() {
      _isLoading = false;
    });
    // ignore: use_build_context_synchronously
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add product"),
        actions: [
          IconButton(
            onPressed: _saveForm,
            icon: const Icon(Icons.save),
          )
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(15.0),
              child: Form(
                key: _form,
                child: ListView(
                  children: [
                    TextFormField(
                      initialValue: _product.title,
                      decoration: const InputDecoration(label: Text('Title')),
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        return value!.isEmpty
                            ? "Please provide a value."
                            : value.length < 2
                                ? "The title must be longer than 1 characters."
                                : null;
                      },
                      onSaved: (newValue) {
                        _product = Product(
                          id: _product.id,
                          isFavorite: _product.isFavorite,
                          title: (newValue) as String,
                          description: _product.description,
                          imageUrl: _product.imageUrl,
                          price: _product.price,
                        );
                      },
                    ),
                    TextFormField(
                      initialValue:
                          _product.price == 0 ? '' : _product.price.toString(),
                      decoration: const InputDecoration(label: Text('Price')),
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      onSaved: (newValue) {
                        _product = Product(
                          id: _product.id,
                          isFavorite: _product.isFavorite,
                          title: _product.title,
                          description: _product.description,
                          imageUrl: _product.imageUrl,
                          price: double.parse(newValue as String),
                        );
                      },
                      validator: (value) {
                        return value!.isEmpty
                            ? "Please provide a value."
                            : double.tryParse(value) == null
                                ? "Please enter a valid price."
                                : double.parse(value) == 0.0
                                    ? "The price must be more than 0.0."
                                    : null;
                      },
                    ),
                    TextFormField(
                      initialValue: _product.description,
                      decoration:
                          const InputDecoration(label: Text('Description')),
                      maxLines: 3,
                      keyboardType: TextInputType.multiline,
                      onSaved: (newValue) {
                        _product = Product(
                          id: _product.id,
                          isFavorite: _product.isFavorite,
                          title: _product.title,
                          description: newValue as String,
                          imageUrl: _product.imageUrl,
                          price: _product.price,
                        );
                      },
                      validator: (value) {
                        return value!.isEmpty
                            ? "Please provide a value."
                            : value.length < 5
                                ? "The Description must be longer than 5 characters."
                                : null;
                      },
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          margin: const EdgeInsets.only(top: 8, right: 10),
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 1,
                              color: Colors.grey,
                            ),
                          ),
                          child: _imageController.text.isEmpty
                              ? const Text("Enter the url")
                              : FittedBox(
                                  fit: BoxFit.cover,
                                  child: Image.network(_imageController.text),
                                ),
                        ),
                        Expanded(
                          child: TextFormField(
                            decoration:
                                const InputDecoration(label: Text('Image URL')),
                            keyboardType: TextInputType.url,
                            textInputAction: TextInputAction.done,
                            controller: _imageController,
                            focusNode: _imageFocusNode,
                            onFieldSubmitted: (_) {
                              _saveForm();
                            },
                            onSaved: (newValue) {
                              _product = Product(
                                id: _product.id,
                                isFavorite: _product.isFavorite,
                                title: _product.title,
                                description: _product.description,
                                imageUrl: newValue as String,
                                price: _product.price,
                              );
                            },
                            validator: (value) {
                              return value!.isEmpty
                                  ? "Please provide a value."
                                  : (!value.startsWith("https") &&
                                              !value.startsWith("http")) ||
                                          (!value.endsWith(".png") &&
                                              !value.endsWith(".jpg") &&
                                              !value.endsWith(".jpeg"))
                                      ? "Please enter a real image URL"
                                      : null;
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
