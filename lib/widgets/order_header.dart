import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shopkeeper/blocs/user_bloc.dart';

class OrderHeader extends StatelessWidget {
  final DocumentSnapshot order;

  const OrderHeader({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final userBloc = UserBloc();

    return Row(
      children: [
        Expanded(
          child: StreamBuilder<List>(
              stream: userBloc.outUsers,
              builder: (context, snapshot) {
                final user = userBloc.getUsers(order.get("clientId"));
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(user != null ? "${user["name"]}" : ""),
                    Text(user != null ? "${user["address"]}" : "")
                    // Text("${_user["name"]}"),
                    // Text("${_user["address"]}"),
                  ],
                );
              }),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
                'Produto: R\$${order.get('productsPrice').toStringAsFixed(2)}'),
            Text('Total: R\$${order.get('totalPrice').toStringAsFixed(2)}')
          ],
        ),
      ],
    );
  }
}
