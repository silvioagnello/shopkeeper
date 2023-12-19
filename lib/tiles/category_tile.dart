import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shopkeeper/pages/product_page.dart';

class CategoryTile extends StatelessWidget {
  final DocumentSnapshot category;

  const CategoryTile({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Card(
        child: ExpansionTile(
          leading: GestureDetector(
            onTap: () {
              // showDialog(
              //     context: context,
              //     builder: (context) => EditCategoryDialog(
              //           category: category,
              //         ));
            },
            child: CircleAvatar(
              backgroundImage: NetworkImage(category.get('icon')),
              //data["icon"]),
              backgroundColor: Colors.transparent,
            ),
          ),
          title: Text(
            category.get('title'), // data["title"],
            style:
                TextStyle(color: Colors.grey[850], fontWeight: FontWeight.w500),
          ),
          children: <Widget>[
            FutureBuilder<QuerySnapshot>(
              future: category.reference.collection("itens").get(),
              //getDocuments(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return Container();
                return Column(
                  children: snapshot.data!.docs.map((doc) {
                    return ListTile(
                      leading: CircleAvatar(
                          backgroundImage: NetworkImage(doc.get("images")[0])),
                      title: Text(doc.get("title")),
                      trailing:
                          Text("R\$${doc.get("price").toStringAsFixed(2)}"),
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ProductPage(
                                  categoryId: category.id,
                                  product: doc,
                                )));
                      },
                    );
                  }).toList()
                    ..add(ListTile(
                      leading: const CircleAvatar(
                        backgroundColor: Colors.transparent,
                        child: Icon(Icons.add, color: Colors.pinkAccent),
                      ),
                      title: const Text("Adicionar"),
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ProductPage(
                                  categoryId: category.id,
                                )));
                      },
                    )),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
