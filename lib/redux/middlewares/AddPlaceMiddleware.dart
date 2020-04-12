import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:myplaces/commons/LoadingDialog.dart';
import 'package:redux/redux.dart';
import '../../AppRoutes.dart';
import '../Actions.dart';
import '../AppState.dart';

List<Middleware<AppState>> createAddPlaceMiddlewares() {
  return <Middleware<AppState>>[
    TypedMiddleware<AppState, AddPlaceAction>(_addPlace),
  ];
}

void showError(BuildContext context) {
  Navigator.of(context).pop();
  Scaffold.of(context).showSnackBar(
      SnackBar(
          duration: const Duration(seconds: 1),
          backgroundColor: Theme.of(context).backgroundColor,
          content: Text('Une erreur est survenue, veuillez réessayer.', style: Theme.of(context).textTheme.body2)
      )
  );
}

void showTimeoutError(BuildContext context) {
  Navigator.of(context).pop();
  Scaffold.of(context).showSnackBar(
      SnackBar(
          duration: const Duration(seconds: 1),
          backgroundColor: Theme.of(context).backgroundColor,
          content: Text('Opération annulée: le serveur met trop de temps à répondre, vérifiez votre réseau.', style: Theme.of(context).textTheme.body2)
      )
  );
}

void showSuccess(BuildContext context) {
  Navigator.of(context).pop();
  Scaffold.of(context).showSnackBar(
      SnackBar(
          duration: const Duration(seconds: 1),
          backgroundColor: Colors.green.shade800,
          content: Text('Nouvelle place ajoutée', style: Theme.of(context).textTheme.body2)
      )
  );
}

Future<void> _createPlace(Store<AppState> store, AddPlaceAction action, String downloadUrl) async {
  final Firestore         _fireStore = Firestore.instance;
  // CREATE A NEW PLACE DOCUMENT IN COLLECTION 'PLACES'
  _fireStore.collection('places').add(<String, dynamic>{
    'title': action.name,
    'description': action.description,
    'imageUrl': downloadUrl,
    'location': <String, double>{'lat': action.position.latitude, 'lng': action.position.longitude},
    'uid': store.state.user.uid
  })
  .then((DocumentReference docRef){
    // SET PLACE DOCUMENT REFERENCE FROM COLLECTION 'PLACES' TO USER ARRAY 'PLACES'
    _fireStore.collection('users').where('uid', isEqualTo: store.state.user.uid).getDocuments()
        .then((QuerySnapshot querySnap){
      final DocumentReference ref = querySnap.documents.first.reference;
      ref.updateData(<String, dynamic>{
        'places' : FieldValue.arrayUnion(<DocumentReference>[docRef])
      }).then((_){
        final GetMPUserAction updateAction = GetMPUserAction(null);
        store.dispatch(updateAction);
        showSuccess(action.context);
      }).catchError((dynamic error) => showError(action.context));
    }).catchError((dynamic error) => showError(action.context));
  }).catchError((dynamic error) => showError(action.context));
}

Future<void> _addPlace(Store<AppState> store, AddPlaceAction action, NextDispatcher next) async {
    showLoadingDialog(action.context);
    const Duration          _timeout = Duration(seconds: 10);
    final String            _uniqueId = UniqueKey().toString();
    final String            _storagePath = store.state.user.uid+'/'+_uniqueId;
    final FirebaseStorage   _fireStorage = FirebaseStorage.instance;
    final StorageReference  storageReference = _fireStorage.ref().child(_storagePath);
    final StorageUploadTask storageUploadTask = storageReference.putFile(action.imageFile);
    try {
      final StorageTaskSnapshot snapshot = await storageUploadTask.onComplete.timeout(_timeout);
      if (storageUploadTask.isSuccessful) {
        snapshot.ref.getDownloadURL().timeout(_timeout)
            .then((dynamic value) {
              final String downloadUrl = value as String;
              _createPlace(store, action, downloadUrl);
        })
            .catchError((dynamic error) {
              storageUploadTask.cancel();
              showError(action.context);
        });
      }
      else {
        storageUploadTask.cancel();
        showError(action.context);
      }
    } on TimeoutException {
      storageUploadTask.cancel();
      showTimeoutError(action.context);
    }
}