import 'dart:io';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:myplaces/commons/LoadingDialog.dart';
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

  static AddPlaceViewModel fromStore(Store<AppState> store) {
    return AddPlaceViewModel._internal(
        route: currentRoute(store.state),
        navigate: (String routeName) => store.dispatch(NavigatePopAction()),
        store: store
    );
  }

  void validateNewPlace(File imageFile, Position position, BuildContext context) {
    showDialog<Map<String, String>>(
      context: context,
      builder: null,
    ).then((dynamic value){
      final AddPlaceAction action = AddPlaceAction(imageFile, position, context);
      showLoadingDialog(context);
      store.dispatch(action);
    });
  }

}