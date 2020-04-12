import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:myplaces/model/MyPlacesUser.dart';

class NavigateReplaceAction {
  NavigateReplaceAction(this.routeName);
  final String routeName;

  @override
  String toString() {
    return 'MainMenuNavigateAction{routeName: $routeName}';
  }
}

class NavigatePushAction {
  NavigatePushAction(this.routeName);
  final String routeName;
  @override
  String toString() {
    return 'NavigatePushAction{routeName: $routeName}';
  }
}

class NavigatePopAction {
  @override
  String toString() {
    return 'NavigatePopAction';
  }
}

class NavigateHomeStartUpAction {
  @override
  String toString() {
    return 'NavigateHomeStartUpAction';
  }
}

class SignInAction {
  SignInAction(this.user, this.context, this.email, this.password);
  final FirebaseUser user;
  final BuildContext context;
  final String email;
  final String password;
  @override
  String toString(){
    return 'SignInAction';
  }
}

class SignUpAction {
  SignUpAction(this.user, this.context, this.email, this.password, this.firstName, this.lastName);
  final FirebaseUser user;
  final BuildContext context;
  final String email;
  final String password;
  final String firstName;
  final String lastName;
  @override
  String toString(){
    return 'SignUpAction';
  }
}

class DisconnectAction {
  @override
  String toString() {
    return 'DisconnectAction';
  }
}

class AddPlaceAction {
  AddPlaceAction(this.imageFile, this.position, this.name, this.description, this.context);
  File     imageFile;
  Position position;
  String   name;
  String   description;
  BuildContext context;

  @override
  String toString() {
    return 'AddPlaceAction';
  }
}

class DelPlaceAction {
  DelPlaceAction(this.uid, this.placeNumber,this.context);
  String   uid; // Places id
  int placeNumber; 
  BuildContext context;

  @override
  String toString() {
    return 'DelPlaceAction';
  }
}

class GetMPUserAction {
  MyPlacesUser user;
  @override
  String toString() {
    return 'GetMPUserAction';
  }
}
