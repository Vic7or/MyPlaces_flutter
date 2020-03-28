import 'package:firebase_auth/firebase_auth.dart';
import 'package:redux/redux.dart';
import '../Actions.dart';

final Reducer<FirebaseUser> authReducer = combineReducers<FirebaseUser>(<FirebaseUser Function(FirebaseUser, dynamic)>[
  TypedReducer<FirebaseUser, SignInAction>(_signIn),
  TypedReducer<FirebaseUser, DisconnectAction>(_signOut),
]);

FirebaseUser _signIn(FirebaseUser user, SignInAction action) => action.user;
FirebaseUser _signOut(FirebaseUser user, DisconnectAction action) => null;