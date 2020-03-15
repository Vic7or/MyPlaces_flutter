import 'package:redux/redux.dart';
import '../../main.dart';
import '../Actions.dart';
import '../AppState.dart';

List<Middleware<AppState>> createNavigationMiddlewares() {
  return <Middleware<AppState>>[
    TypedMiddleware<AppState, NavigateReplaceAction>(_navigateReplace),
    TypedMiddleware<AppState, NavigatePushAction>(_navigate),
  ];
}

void _navigateReplace(Store<AppState> store, dynamic action, NextDispatcher next) {
  final String routeName = (action as NavigateReplaceAction).routeName;
  print(store.state.route);
  if (store.state.route.isEmpty || store.state.route.last != routeName) {
    navigatorKey.currentState.pushReplacementNamed(routeName);
  }
  next(action); //This need to be after name checks
}

void _navigate(Store<AppState> store, dynamic action, NextDispatcher next) {
  final String routeName = (action as NavigatePushAction).routeName;
  if (store.state.route.last != routeName) {
    navigatorKey.currentState.pushNamed(routeName);
  }
  next(action); //This need to be after name checks
}
