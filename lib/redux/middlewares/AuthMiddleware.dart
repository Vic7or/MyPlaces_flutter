import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myplaces/commons/LoadingDialog.dart';
import '../../AppRoutes.dart';
import '../Actions.dart';
import '../AppState.dart';

List<Middleware<AppState>> createAuthMiddlewares() {
  return <Middleware<AppState>>[
    TypedMiddleware<AppState, SignInAction>(_signIn),
    TypedMiddleware<AppState, SignUpAction>(_signUp),
    TypedMiddleware<AppState, DisconnectAction>(_disconnect),
  ];
}

Future<void> _signIn(Store<AppState> store, SignInAction action, NextDispatcher next) async {
  final NavigateReplaceAction navAction = NavigateReplaceAction(AppRoutes.home);
  if (action.user != null){
    next(action);
    if (action.context != null)
      store.dispatch(navAction);
    else {
      final NavigateHomeStartUpAction homeAction = NavigateHomeStartUpAction();
      store.dispatch(homeAction);
    }
  }
  else {
    showLoadingDialog(action.context);
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final AuthResult result = await _auth.signInWithEmailAndPassword(email: action.email, password: action.password);
    Navigator.of(action.context).pop();
    if (result.user != null){
      final SignInAction signInSuccess = SignInAction(result.user, action.context, null, null);
      next(signInSuccess);
      store.dispatch(navAction);
    }
  }
}

Future<void> _signUp(Store<AppState> store, SignUpAction action, NextDispatcher next) async {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  showLoadingDialog(action.context);
  final AuthResult result = await _auth.createUserWithEmailAndPassword(email: action.email, password: action.password);
  Navigator.of(action.context).pop();
  if (result.user != null){
    final String firstName = action.firstName;
    final String lastName = action.lastName;
    final Firestore _fireStore = Firestore.instance;
    await _fireStore.collection('users').add(<String, dynamic>{
      'uid': result.user.uid,
      'email': result.user.email,
      'firstName': firstName,
      'lastName': lastName
    });
    Scaffold.of(action.context).showSnackBar(
      SnackBar(
        content: Text('Votre compte a bien été crée, bienvenue $firstName $lastName!'),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    ).closed.then((_) {
      final SignInAction signInSuccess = SignInAction(result.user, action.context, null, null);
      final SignUpAction signUpSuccess = SignUpAction(result.user, action.context, null, null, action.firstName, action.lastName);
      store.dispatch(signInSuccess);
      next(signUpSuccess);
    });
  }
  else
    Scaffold.of(action.context).showSnackBar(
        SnackBar(
          content: const Text('Une erreur est survenue, veuillez réessayer.'),
          backgroundColor: Colors.red,
        ),
    );
}

Future<void> _disconnect(Store<AppState> store, DisconnectAction action, NextDispatcher next) async {
  final NavigateReplaceAction navAction = NavigateReplaceAction(AppRoutes.signIn);
  final FirebaseAuth _auth = FirebaseAuth.instance;
  await _auth.signOut();
  next(action);
  store.dispatch(navAction);
}
