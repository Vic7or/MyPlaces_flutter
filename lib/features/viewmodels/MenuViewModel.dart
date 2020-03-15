import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import '../../redux/Actions.dart';
import '../../redux/AppState.dart';
import '../../redux/Selectors.dart';
import 'ViewModel.dart';

class MenuViewModel extends ViewModel {

  MenuViewModel._internal({@required List<String> route, @required Function(String) navigate, @required Store<AppState> store}){
    super.route = route;
    super.navigate = navigate;
    super.store = store;
  }

  String email;
  String password;

  static MenuViewModel fromStore(Store<AppState> store) {
    return MenuViewModel._internal(
        route: currentRoute(store.state),
        navigate: (String routeName) => store.dispatch(NavigateReplaceAction(routeName)),
        store: store
    );
  }

  void disconnectPressed(){
      final DisconnectAction action = DisconnectAction();
      store.dispatch(action);
  }
}