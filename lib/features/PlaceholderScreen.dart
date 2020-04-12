
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:myplaces/features/viewmodels/AuthViewModel.dart';
import 'package:myplaces/features/viewmodels/ViewModel.dart';
import 'package:myplaces/redux/AppState.dart';
import 'package:redux/redux.dart';
import './menu/MainMenu.dart';

class PlaceholderScreen extends StatelessWidget {



  Widget _getBody() => const Center(
    child: Text('Placeholder Screen'),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (BuildContext context) {
          return StoreConnector<AppState, ViewModel>(
            distinct: true,
            converter: (Store<AppState> store) => AuthViewModel.fromStore(store),
            builder: (BuildContext context, ViewModel vm) {
              return MainMenu(_getBody());
            },
          );
        }
      ),
    );
  }
}
