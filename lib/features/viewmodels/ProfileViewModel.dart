import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import '../../redux/Actions.dart';
import '../../redux/AppState.dart';
import '../../redux/Selectors.dart';
import 'ViewModel.dart';

class ProfileViewModel extends ViewModel {
  ProfileViewModel._internal({@required List<String> route, @required Function(String, Map<String, dynamic>) navigate, @required Store<AppState> store}){
    super.route = route;
    super.navigate = navigate;
    super.store = store;
  }

String name;
String firstName;

  static ProfileViewModel fromStore(Store<AppState> store) {
    return ProfileViewModel._internal(
      route: currentRoute(store.state),
      navigate: (String routeName, Map<String, dynamic> args) => store.dispatch(NavigateReplaceAction(routeName)),
      store: store
    );
  }
}