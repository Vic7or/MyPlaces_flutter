import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:redux/redux.dart';
import '../Actions.dart';
import '../AppState.dart';

List<Middleware<AppState>> createdelPlaceMiddlewares() {
  return <Middleware<AppState>>[
    TypedMiddleware<AppState, AddPlaceAction>(_delPlace),
  ];
}

Future<void> _delPlace(Store<AppState> store, AddPlaceAction action, NextDispatcher next) async {
  final Firestore         _fireStore = Firestore.instance;
  // CREATE A NEW PLACE DOCUMENT IN COLLECTION 'PLACES'
  _fireStore.collection('users').document('oCGfhV3LwDfRYzYYWBQn').delete();
}