import 'package:myplaces/model/MyPlacesUser.dart';
import 'package:redux/redux.dart';
import '../Actions.dart';

final Reducer<MyPlacesUser> myPlacesUserReducer = combineReducers<MyPlacesUser>(<MyPlacesUser Function(MyPlacesUser, dynamic)>[
  TypedReducer<MyPlacesUser, GetMPUserAction>(_getMyPlacesUser)
]);

MyPlacesUser _getMyPlacesUser(MyPlacesUser user, GetMPUserAction action) => action.user;