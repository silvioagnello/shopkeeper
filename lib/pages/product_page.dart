import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shopkeeper/blocs/product_bloc.dart';
import 'package:shopkeeper/validators/product_validators.dart';
import 'package:shopkeeper/widgets/image_widget.dart';

class ProductPage extends StatefulWidget {
  final String categoryId;
  final DocumentSnapshot? product;

  const ProductPage({super.key, required this.categoryId, this.product});

  @override
  _ProductPageState createState() => _ProductPageState(categoryId, product!);
}

class _ProductPageState extends State<ProductPage> with ProductValidator {
  final ProductBloc productBloc;

  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  _ProductPageState(String categoryId, DocumentSnapshot product)
      : productBloc = ProductBloc(categoryId: categoryId, product: product);

  @override
  Widget build(BuildContext context) {
    InputDecoration buildDecoration(String label) {
      return InputDecoration(
          labelText: label, labelStyle: const TextStyle(color: Colors.grey));
    }

    const fieldStyle = TextStyle(color: Colors.white, fontSize: 16);

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.grey[850],
      appBar: AppBar(
        elevation: 0,
        title: StreamBuilder<bool>(
            stream: productBloc.outCreated,
            initialData: false,
            builder: (context, snapshot) {
              return Text(snapshot.data! ? "Editar Produto" : "Criar Produto");
            }),
        actions: <Widget>[
          StreamBuilder<bool>(
            stream: productBloc.outCreated,
            initialData: false,
            builder: (context, snapshot) {
              if (snapshot.data!) {
                return StreamBuilder<bool>(
                    stream: productBloc.outLoading,
                    initialData: false,
                    builder: (context, snapshot) {
                      return IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: snapshot.data!
                            ? null
                            : () {
                                productBloc.deleteProduct();
                                Navigator.of(context).pop();
                              },
                      );
                    });
              } else {
                return Container();
              }
            },
          ),
          StreamBuilder<bool>(
              stream: productBloc.outLoading,
              initialData: false,
              builder: (context, snapshot) {
                return IconButton(
                  icon: const Icon(Icons.save),
                  onPressed: snapshot.data! ? null : saveProduct,
                );
              }),
        ],
      ),
      body: Stack(
        children: <Widget>[
          Form(
            key: _formKey,
            child: StreamBuilder<Map>(
                stream: productBloc.outData,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return Container();
                  return ListView(
                    padding: const EdgeInsets.all(16),
                    children: <Widget>[
                      const Text(
                        "Imagens",
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                      ImagesWidget(
                        context: context,
                        initialValue: snapshot.data?["images"],
                        onSaved: (y) {}, //productBloc.saveImages,
                        validator: validateImages,
                      ),
                      TextFormField(
                          initialValue: snapshot.data?["title"],
                          style: fieldStyle,
                          decoration: buildDecoration("Título"),
                          onSaved: (y) {},
                          //productBloc.saveTitle,
                          validator: (validateTitle) {
                            return null;
                          } //validateTitle,
                          ),
                      TextFormField(
                          initialValue: snapshot.data?["description"],
                          style: fieldStyle,
                          maxLines: 6,
                          decoration: buildDecoration("Descrição"),
                          onSaved: (y) {},
                          //productBloc.saveDescription,
                          validator: (validateDescription) {
                            return null;
                          } //validateDescription,
                          ),
                      TextFormField(
                          initialValue:
                              snapshot.data?["price"]?.toStringAsFixed(2),
                          style: fieldStyle,
                          decoration: buildDecoration("Preço"),
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
                          onSaved: (y) {},
                          //productBloc.savePrice,
                          validator: (validatePrice) {
                            return null;
                          } //validatePrice,
                          ),
                      const SizedBox(height: 16),
                      const Text("Tamanhos",
                          style: TextStyle(color: Colors.grey, fontSize: 12)),
                      // ProductSizes(
                      //   context: context,
                      //   initialValue: snapshot.data["sizes"],
                      //   onSaved: productBloc.saveSizes,
                      //   validator: (s) {
                      //     if (s.isEmpty) return "";
                      //   },
                      // )
                    ],
                  );
                }),
          ),
          StreamBuilder<bool>(
              stream: productBloc.outLoading,
              initialData: false,
              builder: (context, snapshot) {
                return IgnorePointer(
                  ignoring: snapshot.data!,
                  child: Container(
                    color: snapshot.data! ? Colors.black54 : Colors.transparent,
                  ),
                );
              }),
        ],
      ),
    );
  }

  void saveProduct() async {
    // if (_formKey.currentState.validate()) {
    //   _formKey.currentState.save();
    //
    //   _scaffoldKey.currentState!.showSnackBar(const SnackBar(
    //     content: Text(
    //       "Salvando produto...",
    //       style: TextStyle(color: Colors.white),
    //     ),
    //     duration: Duration(minutes: 1),
    //     backgroundColor: Colors.pinkAccent,
    //   ));
    //
    //   bool success = await productBloc.saveProduct();
    //
    //   _scaffoldKey.currentState?.removeCurrentSnackBar();
    //
    //   _scaffoldKey.currentState?.showSnackBar(SnackBar(
    //     content: Text(
    //       success ? "Produto salvo!" : "Erro ao salvar produto!",
    //       style: const TextStyle(color: Colors.white),
    //     ),
    //     backgroundColor: Colors.pinkAccent,
    //   ));
    // }
  }
}
