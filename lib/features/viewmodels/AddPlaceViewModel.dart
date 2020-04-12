import 'dart:io';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:redux/redux.dart';
import '../../redux/Actions.dart';
import '../../redux/AppState.dart';
import '../../redux/Selectors.dart';
import 'ViewModel.dart';

class AddPlaceViewModel extends ViewModel {
  AddPlaceViewModel._internal({@required List<String> route, @required Function(String, Map<String, dynamic>) navigate, @required Store<AppState> store}){
    super.route = route;
    super.navigate = navigate;
    super.store = store;
  }

  String    name;
  String    description;

  static AddPlaceViewModel fromStore(Store<AppState> store) {
    return AddPlaceViewModel._internal(
        route: currentRoute(store.state),
        navigate: (String routeName, Map<String, dynamic> args) => store.dispatch(NavigatePopAction()),
        store: store
    );
  }

  void validateNewPlace(File imageFile, Position position, BuildContext context) {
      final AddPlaceAction action = AddPlaceAction(imageFile, position, name, description, context);
      store.dispatch(action);
  }

}