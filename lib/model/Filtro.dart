import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Filtro{
  int _id = 0;
  int _grupo = 0;
  String _descricao = "";
  int _tipo = 0;
  String _imagem = "";

  Filtro();

  Filtro.fromJson(Map <dynamic, dynamic> json)
  {
    _id = json['id'];
    _grupo = json['grupo'];
    _descricao = json['descricao'];
    _tipo = json['tipo'];
    _imagem = json['imagem'];
  }

  Map<String, dynamic> toJson()
  {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['grupo'] = this._grupo;
    data['descricao'] = this._descricao;
    data['tipo'] = this._tipo;
    data['imagem'] = this._imagem;
    return data;
  }

  int get tipo => _tipo;

  set tipo(int value) {
    _tipo = value;
  }

  String get descricao => _descricao;

  set descricao(String value) {
    _descricao = value;
  }

  int get grupo => _grupo;

  set grupo(int value) {
    _grupo = value;
  }

  int get id => _id;

  set id(int value) {
    _id = value;
  }


  String get imagem => _imagem;

  set imagem(String value) {
    _imagem = value;
  }

  recuperar_filtros_firebase() async{

    await Firebase.initializeApp();
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference ref_storage = storage.ref().child("filtro");

    List<Filtro> lista_filtros = [];
    final ref = FirebaseDatabase.instance.ref();
    final snapshot = await ref.child("filtro").get();
    if (snapshot.exists) {
      final json = snapshot.value as Map<dynamic, dynamic>;
      for(DataSnapshot ds in snapshot.children)
      {
        Filtro _filtro = Filtro();
        final json = ds.value as Map<dynamic, dynamic>;
        _filtro = Filtro.fromJson(json);

        String img = "";
        img = "g" + _filtro._grupo.toString() + "-t" + _filtro.tipo.toString() + ".png";
        var imageUrl = await ref_storage.child(img).getDownloadURL();
        //var imageUrl = "https://firebasestorage.googleapis.com/v0/b/sandra-foods-app.appspot.com/o/filtro%2Fg1-t1.png?alt=media&token=111162e2-84b0-4a8c-be99-ade43cd62884";
        _filtro.imagem = imageUrl;

        /*try{
          await FirebaseCacheManager.instance.preCache(
            url: FirebaseUrl(_filtro.imagem),
          );
        }
        catch(e){
            print(e.toString());
        }*/

        lista_filtros.add(_filtro);
      }
    }
    return lista_filtros;
  }
}