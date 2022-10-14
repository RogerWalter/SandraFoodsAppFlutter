import 'dart:ui';

import 'package:flutter/material.dart';

class Design{
  Design();

  BoxDecoration container_grad_branco_laranja = BoxDecoration(
    borderRadius: BorderRadius.circular(15),
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment(0.8, 1),
      colors: <Color>[
        Color(0xffffffff).withOpacity(0.4),
        Color(0xffffeadc).withOpacity(0.4),
        Color(0xffffd5ba).withOpacity(0.4),
        Color(0xffffc099).withOpacity(0.4),
        Color(0xffffab78).withOpacity(0.4),
        Color(0xffff9657).withOpacity(0.4),
        Color(0xffff8035).withOpacity(0.4),
        Color(0xffff6900).withOpacity(0.4),
      ], // Gradient from https://learnui.design/tools/gradient-generator.html
      tileMode: TileMode.mirror,
    ),
  );

  BoxDecoration container_transparente = BoxDecoration(
    borderRadius: BorderRadius.circular(15),
    color: Colors.transparent,
  );
}
class MyCustomScrollBehavior extends MaterialScrollBehavior {
  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
  };
}