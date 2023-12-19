import 'package:flutter/material.dart';
import 'package:shopkeeper/blocs/login_bloc.dart';

import '../widgets/input_field.dart';
import 'home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  final _loginBloc = LoginBloc();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _loginBloc.outState.listen((state) {
      switch (state) {
        case LoginState.success:
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const HomePage()));
          break;
        case LoginState.fail:
          showDialog(
              context: context,
              builder: (context) => const AlertDialog(
                    title: Text("Erro"),
                    content: Text("Você não possui os privilégios necessários"),
                  ));
          break;
        case LoginState.loading:
        case LoginState.idle:
      }
    });
  }

  @override
  void dispose() {
    _loginBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: StreamBuilder<LoginState>(
        stream: _loginBloc.outState,
        initialData: LoginState.loading,
        builder: (context, snapshot) {
          if (snapshot.data == LoginState.loading) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.data == LoginState.success ||
              snapshot.data == LoginState.fail ||
              snapshot.data == LoginState.idle) {
            return Stack(
              children: [
                Container(),
                SingleChildScrollView(
                  child: Column(
                    //crossAxisAlignment: CrossAxisAlignment.stretch,
                    // mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Image(
                          image: AssetImage('assets/icons/market.png'),
                          width: 150),
                      InputField(
                        icon: Icons.person_outline,
                        hint: 'Usuário(email)',
                        obscure: false,
                        //controller: _emailController
                        stream: _loginBloc.outEmail,
                        onChanged: _loginBloc.changeEmail,
                      ),
                      InputField(
                        icon: Icons.lock_outline,
                        hint: 'Senha(min.6 digts)',
                        obscure: true,
                        //controller: _passController
                        stream: _loginBloc.outPass,
                        onChanged: _loginBloc.changePass,
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      StreamBuilder<Object>(
                        stream: _loginBloc.outSubmit,
                        builder: (context, snapshot) {
                          return SizedBox(
                            height: 50,
                            child: ElevatedButton(
                              style: raisedButtonStyle,
                              onPressed:
                                  snapshot.hasData ? _loginBloc.submit : null,
                              child: const Text("Entrar"),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            );
          } else {
            throw Exception('Requisição inválida!');
          }
        },
      ),
    );
  }

  final ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
    foregroundColor: Colors.white,
    backgroundColor: Colors.pink.shade400,
    textStyle: const TextStyle(color: Colors.white),
    minimumSize: const Size(88, 36),
    padding: const EdgeInsets.symmetric(horizontal: 16),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(2)),
    ),
  );

  void _onSuccess() {
    Navigator.of(context).pop();
  }

  void _onFail() {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text("Falha ao criar entrar!"),
      backgroundColor: Colors.redAccent,
      duration: Duration(seconds: 2),
    ));
  }
}
