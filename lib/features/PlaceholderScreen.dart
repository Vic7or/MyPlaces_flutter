
import 'package:flutter/material.dart';
import './menu/MainMenu.dart';

class PlaceholderScreen extends StatelessWidget {

  Widget _getBody() => const Center(
    child: Text('Placeholder Screen'),
  );

  @override
  Widget build(BuildContext context) {
    return MainMenu(_getBody());
  }

}
