import 'package:redux/redux.dart';
import '../AppState.dart';
import 'AddPlaceMiddleware.dart';
import 'AuthMiddleware.dart';
import 'NavigationMiddleware.dart';

List<Middleware<AppState>> createAppMiddlewares(){
  final List<Middleware<AppState>> navigationMiddlewares = createNavigationMiddlewares();
  final List<Middleware<AppState>> authMiddlewares = createAuthMiddlewares();
  final List<Middleware<AppState>> addPlaceMiddlewares = createAddPlaceMiddlewares();
  final List<Middleware<AppState>> middlewares = <Middleware<AppState>>[];
  middlewares.addAll(navigationMiddlewares);
  middlewares.addAll(authMiddlewares);
  middlewares.addAll(addPlaceMiddlewares);
  return middlewares;
}