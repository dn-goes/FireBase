import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:todo_list_firebase/firebase_options.dart';
import 'package:todo_list_firebase/views/auth_view.dart';

void main() async{ 
  WidgetsFlutterBinding.ensureInitialized();  //garante que o Flutter esteja totalmente inicializado
  //conectar com o Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform  //pega as opções corretas conforme a plataforma (android, ios, web, etc
  );
  runApp(MaterialApp(
    title: "Lista de Tarefas com firebase",
    home: AuthView(), //tela de autenticação
  ));
}