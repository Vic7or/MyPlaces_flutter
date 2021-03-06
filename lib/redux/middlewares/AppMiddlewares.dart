import 'package:myplaces/redux/middlewares/FavoriteMiddleware.dart';
import 'package:redux/redux.dart';
import '../AppState.dart';
import 'AddPlaceMiddleware.dart';
import 'AuthMiddleware.dart';
import 'DelPlaceMiddleware.dart';
import 'MyPlacesUserMiddleware.dart';
import 'NavigationMiddleware.dart';
import 'ProfilePictureMiddleware.dart';


List<Middleware<AppState>> createAppMiddlewares(){
  final List<Middleware<AppState>> navigationMiddlewares = createNavigationMiddlewares();
  final List<Middleware<AppState>> authMiddlewares = createAuthMiddlewares();
  final List<Middleware<AppState>> addPlaceMiddlewares = createAddPlaceMiddlewares();
  final List<Middleware<AppState>> myPlacesUserMiddlewares = createMyPlacesUserMiddlewares();
  final List<Middleware<AppState>> favoriteMiddlewares = createFavoriteMiddlewares();
  final List<Middleware<AppState>> delPlaceMiddlewares = createDelPlaceMiddlewares();
  final List<Middleware<AppState>> profilePictureMiddlewares = createProfilePictureMiddlewares();
  final List<Middleware<AppState>> middlewares = <Middleware<AppState>>[];
  middlewares.addAll(navigationMiddlewares);
  middlewares.addAll(authMiddlewares);
  middlewares.addAll(addPlaceMiddlewares);
  middlewares.addAll(myPlacesUserMiddlewares);
  middlewares.addAll(favoriteMiddlewares);
  middlewares.addAll(delPlaceMiddlewares);
  middlewares.addAll(profilePictureMiddlewares);
  return middlewares;
}