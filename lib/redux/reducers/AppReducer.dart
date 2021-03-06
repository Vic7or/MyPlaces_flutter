import '../AppState.dart';
import './AuthReducer.dart';
import './MyPlaceUserReducer.dart';
import './NavigationReducer.dart';

AppState appReducer(AppState state, dynamic action) {
  final AppState newState =  AppState(
    route: navigationReducer(state.route, action),
    user: authReducer(state.user, action),
    mpUser: myPlacesUserReducer(state.mpUser, action)
  );
  //print('old state before $action => '+state.toString());
  //print('new state after $action => '+newState.toString());
  return newState;
}
