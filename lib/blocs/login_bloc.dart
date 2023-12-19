import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shopkeeper/validators/login_validators.dart';
import 'dart:async';

enum LoginState { idle, loading, success, fail }

class LoginBloc extends BlocBase with LoginValidators {
  final _emailController = BehaviorSubject<String>();
  final _passwordController = BehaviorSubject<String>();

  final _stateController = BehaviorSubject<LoginState>();

  Stream<LoginState> get outState => _stateController.stream;

  Stream<String> get outEmail =>
      _emailController.stream.transform(validateEmail);

  Stream<String> get outPass =>
      _passwordController.stream.transform(validatePass);

  Stream<bool> get outSubmit =>
      Rx.combineLatest2(outEmail, outPass, (a, b) => true);

  Function(String) get changeEmail => _emailController.sink.add;

  Function(String) get changePass => _passwordController.sink.add;

  late StreamSubscription<User?> _streamSubscription;

  LoginBloc() {
    // FirebaseAuth.instance.signOut();
    _streamSubscription =
        FirebaseAuth.instance.authStateChanges().listen((user) async {
      if (user != null) {
        // _stateController.add(LoginState.success);
        // FirebaseAuth.instance.signOut();
        if (await verifyPrivileges(user)) {
          //print('logou');
          _stateController.add(LoginState.success);
        } else {
          FirebaseAuth.instance.signOut();
          _stateController.add(LoginState.fail);
        }
      } else {
        // print('não logou');
        _stateController.add(LoginState.idle);
      }
    });
  }

  Future submit() async {
    final email = _emailController.value;
    final pass = _passwordController.value;

    _stateController.add(LoginState.loading);

    Future<UserCredential> result = FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: pass)
        .catchError((e) {
      _stateController.add(LoginState.fail);
    });
  }

  Future<bool> verifyPrivileges(User user) async {
    return await FirebaseFirestore.instance
        .collection('admins')
        .doc(user.uid)
        .get()
        .then((doc) {
      if (doc.data() != null) {
        return true;
      } else {
        return false;
      }
    }).catchError((e) {
      return false;
    });
  }

  @override
  void dispose() {
    _passwordController.close();
    _emailController.close();
    _stateController.close();
    _streamSubscription.cancel();
    super.dispose();
  }
}
