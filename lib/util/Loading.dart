import 'package:flutter/material.dart';

class Loading extends StatefulWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: FractionalOffset.center,
        color: Colors.transparent,
        height: 100,
        width: 100,
        padding: const EdgeInsets.all(20.0),
        child:  new Image.asset(
          'images/loading_gif.gif',
          fit: BoxFit.cover,
        )
    );
  }
}

dialogoLoading(BuildContext context, double tamanho){
  return showDialog(
      context: context,
      barrierDismissible: false,
      barrierLabel: MaterialLocalizations.of(context)
          .modalBarrierDismissLabel,
      barrierColor: null,
      builder: (_) => new Dialog(
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: new Container(
            alignment: FractionalOffset.center,
            color: Colors.transparent,
            height: tamanho,
            width: tamanho,
            padding: const EdgeInsets.all(20.0),
            child:  new Image.asset(
              'images/loading_gif.gif',
              fit: BoxFit.cover,
            )
        ),
      ));
}
