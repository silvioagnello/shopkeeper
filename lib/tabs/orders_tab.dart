import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:shopkeeper/blocs/orders_bloc.dart';
import 'package:shopkeeper/tiles/order_tile.dart';

class OrdersTab extends StatelessWidget {
  const OrdersTab({super.key});

  @override
  Widget build(BuildContext context) {
    final _ordersBloc = OrdersBloc();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: StreamBuilder<List>(
          stream: _ordersBloc.outOrders,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(Colors.pinkAccent),
                ),
              );
            } else if (snapshot.data!.isEmpty) {
              return const Center(child: Text('Nenhum Pedido encontrado'));
            } else {
              return ListView.builder(
                itemBuilder: (context, index) {
                  return OrderTile(order: snapshot.data?[index]);
                },
                itemCount: snapshot.data!.length,
              );
            }
          }),
    );
  }
}
