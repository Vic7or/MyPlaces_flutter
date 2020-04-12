import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import '../Actions.dart';
import '../AppState.dart';

List<Middleware<AppState>> createFavoriteMiddlewares() {
  return <Middleware<AppState>>[
    TypedMiddleware<AppState, FavoriteAction>(_favorite),
    TypedMiddleware<AppState, UnFavoriteAction>(_unfavorite),
  ];
}

void _favorite(Store<AppState> store, FavoriteAction action, NextDispatcher next) {
  action.user.updateData(<String, dynamic>{
    'places': FieldValue.arrayRemove(<DocumentReference>[action.place]),
    'favoris': FieldValue.arrayUnion(<DocumentReference>[action.place])
  })
  .then((_){
    final GetMPUserAction updateAction = GetMPUserAction(action.update);
    store.dispatch(updateAction);
    showSuccess(action.context, 'Favoris ajouté !');
  }).catchError((dynamic error) => showError(action.context));
}

void _unfavorite(Store<AppState> store, UnFavoriteAction action, NextDispatcher next) {
  action.user.updateData(<String, dynamic>{
    'places': FieldValue.arrayUnion(<DocumentReference>[action.place]),
    'favoris': FieldValue.arrayRemove(<DocumentReference>[action.place])
  })
  .then((_){
    final GetMPUserAction updateAction = GetMPUserAction(action.update);
    store.dispatch(updateAction);
    showSuccess(action.context, 'Favoris retiré !');
  }).catchError((dynamic error) => showError(action.context));
}

void showSuccess(BuildContext context, String msg) {
  Scaffold.of(context).showSnackBar(
      SnackBar(
          duration: const Duration(seconds: 1),
          backgroundColor: Colors.green.shade800,
          content: Text(msg, style: Theme.of(context).textTheme.body2)
      )
  );
}

void showError(BuildContext context) {
  Scaffold.of(context).showSnackBar(
      SnackBar(
          duration: const Duration(seconds: 1),
          backgroundColor: Theme.of(context).backgroundColor,
          content: Text('Une erreur est survenue, veuillez réessayer.', style: Theme.of(context).textTheme.body2)
      )
  );
}