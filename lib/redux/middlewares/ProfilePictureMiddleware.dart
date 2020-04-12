import 'dart:async';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import '../Actions.dart';
import '../AppState.dart';

List<Middleware<AppState>> createProfilePictureMiddlewares() {
  return <Middleware<AppState>>[
    TypedMiddleware<AppState, UploadProfilePictureAction>(_uploadProfilePicture),
  ];
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

void showTimeoutError(BuildContext context) {
  Scaffold.of(context).showSnackBar(
      SnackBar(
          duration: const Duration(seconds: 1),
          backgroundColor: Theme.of(context).backgroundColor,
          content: Text('Opération annulée: le serveur met trop de temps à répondre, vérifiez votre réseau.', style: Theme.of(context).textTheme.body2)
      )
  );
}

void showSuccess(BuildContext context) {
  Scaffold.of(context).showSnackBar(
      SnackBar(
          duration: const Duration(seconds: 1),
          backgroundColor: Colors.green.shade800,
          content: Text('photo ajoutée !', style: Theme.of(context).textTheme.body2)
      )
  );
}

Future<void> _uploadProfilePicture(Store<AppState> store, UploadProfilePictureAction action, NextDispatcher next) async {
  const Duration          _timeout = Duration(seconds: 10);
  final String            _uniqueId = UniqueKey().toString();
  final String            _storagePath = store.state.user.uid+'/profilePictures/'+_uniqueId;
  final FirebaseStorage   _fireStorage = FirebaseStorage.instance;
  final StorageReference  storageReference = _fireStorage.ref().child(_storagePath);
  final StorageUploadTask storageUploadTask = storageReference.putFile(action.imageFile);
  try {
    final StorageTaskSnapshot snapshot = await storageUploadTask.onComplete.timeout(_timeout);
    if (storageUploadTask.isSuccessful) {
      snapshot.ref.getDownloadURL().timeout(_timeout)
          .then((dynamic value) {
        final String downloadUrl = value as String;
        action.user.updateData(<String, dynamic>{
          'profilePicture': downloadUrl
        }).then((_){
          showSuccess(action.context);
          final GetMPUserAction updateAction = GetMPUserAction(action.update);
          store.dispatch(updateAction);
        }).catchError((dynamic error) => showError(action.context));
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
