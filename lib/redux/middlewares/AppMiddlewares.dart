import 'package:redux/redux.dart';
import '../AppState.dart';
import 'AddPlaceMiddleware.dart';
import 'DelPlaceMiddleware.dart';
import 'AuthMiddleware.dart';
import 'MyPlacesUserMiddleware.dart';
import 'NavigationMiddleware.dart';


List<Middleware<AppState>> createAppMiddlewares(){
  final List<Middleware<AppState>> navigationMiddlewares = createNavigationMiddlewares();
  final List<Middleware<AppState>> authMiddlewares = createAuthMiddlewares();
  final List<Middleware<AppState>> addPlaceMiddlewares = createAddPlaceMiddlewares();
  final List<Middleware<AppState>> delPlaceMiddlewares = createdelPlaceMiddlewares();
  final List<Middleware<AppState>> myPlacesUserMiddlewares = createMyPlacesUserMiddlewares();
  final List<Middleware<AppState>> middlewares = <Middleware<AppState>>[];
  middlewares.addAll(navigationMiddlewares);
  middlewares.addAll(authMiddlewares);
  middlewares.addAll(delPlaceMiddlewares);
  middlewares.addAll(addPlaceMiddlewares);
  middlewares.addAll(myPlacesUserMiddlewares);
  return middlewares;
}