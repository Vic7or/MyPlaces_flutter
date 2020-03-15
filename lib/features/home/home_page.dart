import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:myplaces/features/viewmodels/AuthViewModel.dart';
import 'package:myplaces/features/viewmodels/ViewModel.dart';
import 'package:myplaces/redux/AppState.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import '../menu/MainMenu.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
          builder: (BuildContext context) {
            return StoreConnector<AppState, ViewModel>(
              distinct: true,
              converter: (Store<AppState> store) => AuthViewModel.fromStore(store),
              builder: (BuildContext context, ViewModel vm){
                return MainMenu(
                  ListView.builder(
                    itemCount: vm.store.state.places.length,
                    itemBuilder: (BuildContext context, int i){
                      return Dismissible(
                        key: Key(i.toString()),
                        child: const ListTile(
                          title: Text('Title'),
                          leading: Text('leading'),
                          trailing: Text('trailing'),
                        )
                      );
                    }
                  )
                );
              },
            );
          }
      ),
    );
  }
}