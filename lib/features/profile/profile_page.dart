
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:myplaces/features/viewmodels/ProfileViewModel.dart';
import 'package:myplaces/features/viewmodels/ViewModel.dart';
import 'package:myplaces/redux/AppState.dart';
import 'package:redux/redux.dart';
import '../menu/MainMenu.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key key}) : super(key: key);

  Widget _getBody(ViewModel vm) => Center(
    child: Text(
      "email : " +
      vm.store.state.user.email +
      "\nuid : " +
      vm.store.state.user.uid +
      "\nname : " +
      vm.store.state.user.uid +
      "\nprovider id : " +
      vm.store.state.user.uid +
      "\nphone number : " +
      vm.store.state.user.uid +
      "\nuid : "
      ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (BuildContext context) {
          return StoreConnector<AppState, ViewModel>(
            distinct: true,
            converter: (Store<AppState> store) => ProfileViewModel.fromStore(store),
            builder: (BuildContext context, ViewModel vm) {
              return MainMenu(_getBody(vm));
            },
          );
        }
      ),
    );
  }
}
