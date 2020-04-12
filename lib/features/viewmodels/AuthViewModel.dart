import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import '../../redux/Actions.dart';
import '../../redux/AppState.dart';
import '../../redux/Selectors.dart';
import 'ViewModel.dart';

class AuthViewModel extends ViewModel {
  AuthViewModel._internal({@required List<String> route, @required Function(String, Map<String, dynamic>) navigate, @required Store<AppState> store}){
    super.route = route;
    super.navigate = navigate;
    super.store = store;
  }
  String firstName;
  String lastName;
  String email;
  String password;
  static AuthViewModel fromStore(Store<AppState> store) {
    return AuthViewModel._internal(
      route: currentRoute(store.state),
      navigate: (String routeName, Map<String, dynamic> args) => store.dispatch(NavigateReplaceAction(routeName)),
      store: store
    );
  }
  void signInPressed(GlobalKey<FormState> formKey, BuildContext context){
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      final SignInAction action = SignInAction(null, context, email, password);
      store.dispatch(action);
    }
  }

  void signUpPressed(GlobalKey<FormState> formKey, BuildContext context){
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      final SignUpAction action = SignUpAction(null, context, email, password, firstName, lastName);
      store.dispatch(action);
    }
  }
}