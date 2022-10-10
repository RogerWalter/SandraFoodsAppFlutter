import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

extension CapExtension on String {
  String get inCaps => '${this[0].toUpperCase()}${this.substring(1).toLowerCase()}';
  String get allInCaps => this.toUpperCase();
  String get capitalizeFirstofEach => this.split(" ").map((str) => str.inCaps).join(" ");
}

class Taxa{
  int _id = 0;
  String _bairro = "";
  num _valor = 0.0;

  Taxa();

  Taxa.fromJson(Map <dynamic, dynamic> json)
  {
    _id = json['id'];
    _bairro = json['bairro'];
    _valor = json['valor'];
  }

  Map<String, dynamic> toJson()
  {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['bairro'] = this._bairro;
    data['valor'] = this._valor;
    return data;
  }

  num get valor => _valor;

  set valor(num value) {
    _valor = value;
  }

  String get bairro => _bairro;

  set bairro(String value) {
    _bairro = value;
  }

  int get id => _id;

  set id(int value) {
    _id = value;
  }

  recuperar_taxas_firebase() async{
    await Firebase.initializeApp();
    List<Taxa> lista_taxas = [];
    final ref = FirebaseDatabase.instance.ref();
    final snapshot = await ref.child("taxa").get();
    if (snapshot.exists) {
      final json = snapshot.value as Map<dynamic, dynamic>;
      for(DataSnapshot ds in snapshot.children)
      {
        Taxa _taxa = Taxa();
        final json = ds.value as Map<dynamic, dynamic>;
        _taxa = Taxa.fromJson(json);
        String bairro = _taxa._bairro.capitalizeFirstofEach;
        _taxa._bairro = bairro;
        lista_taxas.add(_taxa);
      }
    }
    return lista_taxas;
  }
}