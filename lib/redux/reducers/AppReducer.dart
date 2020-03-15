import '../AppState.dart';
import './AuthReducer.dart';
import './NavigationReducer.dart';
import './loading_reducer.dart';

AppState appReducer(AppState state, dynamic action) {
  final AppState newState =  AppState(
      isLoading: loadingReducer(state.isLoading, action),
      route: navigationReducer(state.route, action),
      user: authReducer(state.user, action)
  );
  print('old state before $action => '+state.toString());
  print('new state after $action => '+newState.toString());
  return newState;
}
