import 'dart:async';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:myplaces/commons/LoadingDialog.dart';
import 'package:redux/redux.dart';
import '../../AppRoutes.dart';
import '../Actions.dart';
import '../AppState.dart';

List<Middleware<AppState>> createUploadProfilePicMiddlewares() {
  return <Middleware<AppState>>[
    TypedMiddleware<AppState, UploadPictureAction>(_uploadProfilePic),
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

Future<void> _uploadProfilePic(Store<AppState> store, UploadPictureAction action, NextDispatcher next) async {
    showLoadingDialog(action.context);
    const Duration          _timeout = Duration(seconds: 10);
    final String            _storagePath = store.state.user.uid+'/profilePictureUrl';
    final FirebaseStorage   _fireStorage = FirebaseStorage.instance;
    final StorageReference  storageReference = _fireStorage.ref().child(_storagePath);
    final StorageUploadTask storageUploadTask = storageReference.putFile(action.imageFile);
    try {
      final StorageTaskSnapshot snapshot = await storageUploadTask.onComplete.timeout(_timeout);
      if (storageUploadTask.isSuccessful) {
        snapshot.ref.getDownloadURL().timeout(_timeout)
            .then((dynamic value) {
              final String downloadUrl = value as String;
              next(downloadUrl);
              print('downloadUrl: $downloadUrl');
              Navigator.of(action.context).pop();
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