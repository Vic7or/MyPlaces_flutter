import 'package:flutter/material.dart';
import 'package:flare_flutter/flare_actor.dart';

void showLoadingDialog(BuildContext context){
  showDialog<dynamic>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return const Material(
        type: MaterialType.transparency,
        child: Center(
            child: FlareActor('assets/animations/Liquid_Loader.flr', animation: 'Untitled')
        ),
      );
    },
  );
}