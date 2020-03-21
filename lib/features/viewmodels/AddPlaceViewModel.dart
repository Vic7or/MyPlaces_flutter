import 'dart:io';
import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import '../../redux/Actions.dart';
import '../../redux/AppState.dart';
import '../../redux/Selectors.dart';
import 'ViewModel.dart';

class AddPlaceViewModel extends ViewModel {
  AddPlaceViewModel._internal({@required List<String> route, @required Function(String) navigate, @required Store<AppState> store}){
    super.route = route;
    super.navigate = navigate;
    super.store = store;
  }

  File _imageFile;

  static AddPlaceViewModel fromStore(Store<AppState> store) {
    return AddPlaceViewModel._internal(
        route: currentRoute(store.state),
        navigate: (String routeName) => store.dispatch(NavigatePopAction()),
        store: store
    );
  }
}