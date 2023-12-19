import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';

enum SortCriteria { readFirst, readyLast }

class OrdersBloc extends BlocBase {
  final _ordersController = BehaviorSubject<List>();

  Stream<List> get outOrders => _ordersController.stream;

  final List<DocumentSnapshot> _orders = [];

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  OrdersBloc() {
    _addOrdersListener();
  }

  late SortCriteria _criteria;

  void _addOrdersListener() {
    _firestore.collection('orders').snapshots().listen((event) {
      for (var element in event.docChanges) {
        String oid = element.doc.id;

        switch (element.type) {
          case DocumentChangeType.added:
            _orders.add(element.doc);
            break;
          case DocumentChangeType.modified:
            _orders.removeWhere((order) => order.id == oid);
            _orders.add(element.doc);
            break;
          case DocumentChangeType.removed:
            _orders.removeWhere((order) => order.id == oid);
            break;
        }
      }
      _ordersController.add(_orders);
    });
  }

  void setOrderCriteria(SortCriteria criteria) {
    _criteria = criteria;

    _sort();
  }

  void _sort() {
    switch (_criteria) {
      case SortCriteria.readFirst:
        _orders.sort((a, b) {
          int sa = a.get("status");
          int sb = b.get("status");

          if (sa < sb) {
            return 1;
          } else if (sa > sb) {
            return -1;
          } else {
            return 0;
          }
        });
        break;
      case SortCriteria.readyLast:
        _orders.sort((a, b) {
          int sa = a.get("status");
          int sb = b.get("status");

          if (sa > sb) {
            return 1;
          } else if (sa < sb) {
            return -1;
          } else {
            return 0;
          }
        });
        break;
    }

    _ordersController.add(_orders);
  }

  @override
  void dispose() {
    _ordersController.close();
  }
}
