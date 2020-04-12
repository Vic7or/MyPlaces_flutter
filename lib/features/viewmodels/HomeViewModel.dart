import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import '../../redux/Actions.dart';
import '../../redux/AppState.dart';
import '../../redux/Selectors.dart';
import 'ViewModel.dart';

class HomeViewModel extends ViewModel {
  HomeViewModel._internal({@required List<String> route, @required Function(String, Map<String, dynamic>) navigate, @required Store<AppState> store}){
    super.route = route;
    super.navigate = navigate;
    super.store = store;
  }

  static HomeViewModel fromStore(Store<AppState> store) {
    return HomeViewModel._internal(
        route: currentRoute(store.state),
        navigate: (String routeName, Map<String, dynamic> args) => store.dispatch(NavigatePushAction(routeName, args)),
        store: store
    );
  }
}