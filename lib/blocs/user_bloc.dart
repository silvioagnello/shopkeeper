import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:rxdart/rxdart.dart';

class UserBloc extends BlocBase {
  final _usersController = BehaviorSubject<List>();

  Stream<List> get outUsers => _usersController.stream;

  final Map<String, Map<String, dynamic>> _users = {};

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  UserBloc() {
    _addUsersListeners();
  }

  void onChangedSearch(String search) {
    if (search.trim().isEmpty) {
      _usersController.add(_users.values.toList());
    } else {
      _usersController.add(_filter(search.trim()));
    }
  }

  List<Map<String, dynamic>> _filter(String search) {
    List<Map<String, dynamic>> filteredUsers =
        List.from(_users.values.toList());
    filteredUsers.retainWhere((user) {
      return user['name'].toUpperCase().contains(search.toUpperCase());
    });
    return filteredUsers;
  }

  void _addUsersListeners() {
    _firestore.collection('users').snapshots().listen((snapshot) {
      for (var change in snapshot.docChanges) {
        String uid = change.doc.id;
        switch (change.type) {
          case DocumentChangeType.added:
            _users[uid] = change.doc.data()!;
            _subscribeToOrders(uid);
            //_usersController.add(_users.values.toList());
            break;

          case DocumentChangeType.modified:
            _users[uid]?.addAll(change.doc.data()!);
            //_unsubscribeToOrders(uid);
            _usersController.add(_users.values.toList());
            break;

          case DocumentChangeType.removed:
            _users.remove(uid);
            _unsubscribeToOrders(uid);
            _usersController.add(_users.values.toList());
            break;
        }
      }
    });
  }

  void _subscribeToOrders(String uid) {
    _users[uid]?['subscription'] = _firestore
        .collection('users')
        .doc(uid)
        .collection('orders')
        .snapshots()
        .listen((orders) async {
      int numOrders = orders.docs.length;
      double money = 0.0;
      for (DocumentSnapshot d in orders.docs) {
        DocumentSnapshot order =
            await _firestore.collection('orders').doc(d.id).get();
        money += order.get('totalPrice');
      }

      _users[uid]?.addAll({'money': money, 'orders': numOrders});
      _usersController.add(_users.values.toList());
    });
  }

  Map<String, dynamic>? getUsers(String uid) {
    return _users[uid];
  }

  void _unsubscribeToOrders(String uid) {
    _users[uid]?['subscription'].cancel();
  }

  @override
  void dispose() {
    _usersController.close();
    super.dispose();
  }
}
