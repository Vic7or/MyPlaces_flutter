import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';

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

class UploadPictureAction {
  UploadPictureAction(this.imageFile, this.user);
  FirebaseUser user;
  File imageFile;
  String downloadUrl;
  BuildContext context;
  @override
  String toString() {
    return 'UploadPictureAction';
  }
}