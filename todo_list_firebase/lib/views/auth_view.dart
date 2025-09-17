import 'package:firebase_auth/firebase_auth.dart'; //clase modelo do User
import 'package:flutter/material.dart';
import 'package:todo_list_firebase/views/login_view.dart';
import 'package:todo_list_firebase/views/tarefas_view.dart';

class AuthView extends StatelessWidget {
  const AuthView({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>( //observa as mudanças de estado do usuário
      //a mudança de tela é determianda pela conexão do usuário ao firebase
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return TarefasView(); //se o usuário estiver logado, mostra a tela de tarefas
        }
        return LoginView(); //se o usuário não estiver logado, mostra a tela de login 
      },
    );
  }
}
