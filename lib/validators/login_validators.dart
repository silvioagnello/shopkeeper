import 'dart:async';

mixin class LoginValidators {
  final validateEmail =
      StreamTransformer<String, String>.fromHandlers(handleData: (email, sink) {
    if (email.contains('@')) {
      sink.add(email);
    } else {
      sink.addError('Insira um Email valido');
    }
  });

  final validatePass =
      StreamTransformer<String, String>.fromHandlers(handleData: (pass, sink) {
    if (pass.length > 5) {
      sink.add(pass);
    } else {
      sink.addError('Senha deve ter mais de 5 caracteres');
    }
  });
}
