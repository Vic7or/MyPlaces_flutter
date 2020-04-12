import 'dart:io';

import 'package:redux/redux.dart';
import '../Actions.dart';

final Reducer<String> uploadReducer = combineReducers<String>(<String Function(String, dynamic)>[
  TypedReducer<String, UploadPictureAction>(_uploadProfilePic),
]);

String _uploadProfilePic(File imageFile, UploadPictureAction action) {
  final String result = action.downloadUrl;
  return result;
}