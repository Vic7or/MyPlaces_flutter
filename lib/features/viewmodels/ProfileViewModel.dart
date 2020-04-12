import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import '../../redux/Actions.dart';
import '../../redux/AppState.dart';
import '../../redux/Selectors.dart';
import 'ViewModel.dart';

class ProfileViewModel extends ViewModel {
  ProfileViewModel._internal({@required List<String> route, @required Function(String) navigate, @required Store<AppState> store}){
    super.route = route;
    super.navigate = navigate;
    super.store = store;
  }

String name;
String firstName;

  void uploadPicture(File imageFile, FirebaseUser user){
      final UploadPictureAction action = UploadPictureAction(imageFile, user);
      store.dispatch(action);
    }

  static ProfileViewModel fromStore(Store<AppState> store) {
    return ProfileViewModel._internal(
      route: currentRoute(store.state),
      navigate: (String routeName) => store.dispatch(NavigateReplaceAction(routeName)),
      store: store
    );
  }
}