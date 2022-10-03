import 'dart:math';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class Frase{
  String _frase = "";

  Frase.fromJson(Map <dynamic, dynamic> json)
  {
    _frase = json['frase'];
  }

  Map<String, dynamic> toJson()
  {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['frase'] = this._frase;
    return data;
  }

  Frase();

  String get frase => _frase;

  set frase(String value) {
    _frase = value;
  }

  Future<String> gerarFraseFirebase(String nome) async{
    String _frase_mostrar = "";
    List<String> frases = <String>[];
    await Firebase.initializeApp();
    final ref = FirebaseDatabase.instance.ref();
    final snapshot = await ref.child("frase").get();
    if (snapshot.exists) {
      for(DataSnapshot ds in snapshot.children){
        String frase_ds = ds.value.toString();
        frases.add(frase_ds);
      }
    } else {
      print('No data available.');
    }
    int x = new Random().nextInt(10);
    _frase_mostrar = frases[x];
    _frase_mostrar = _frase_mostrar.replaceAll('[nome]', nome);
    return _frase_mostrar;
  }
}