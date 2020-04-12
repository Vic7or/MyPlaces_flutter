import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:myplaces/features/authentication/SignUp.dart';
import 'package:myplaces/features/authentication/SignIn.dart';
import 'package:myplaces/features/place/place_page.dart';
import 'package:myplaces/redux/Actions.dart';
import 'package:redux/redux.dart';
import 'AppRoutes.dart';
import 'Localization.dart';
import 'features/favorite/favorite_page.dart';
import 'features/home/home_page.dart';
import 'features/newPlace/NewPlace.dart';
import 'features/profile/profile_page.dart';
import 'redux/AppState.dart';
import 'redux/middlewares/AppMiddlewares.dart';
import 'redux/reducers/AppReducer.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  SystemChrome.setPreferredOrientations(<DeviceOrientation>[DeviceOrientation.portraitUp]).then((_) {
    runApp(MyPlacesApp());
  });
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyPlacesApp extends StatelessWidget {
  final Store<AppState> store = Store<AppState>(appReducer,
      initialState: AppState.loading(),
      middleware: createAppMiddlewares()
  );

  final ThemeData theme = ThemeData(
    backgroundColor: Colors.deepOrange.shade800,
    primaryColor: Colors.orange,
    primaryColorLight: Colors.white,
    primaryColorDark: Colors.black,
    scaffoldBackgroundColor: Colors.orange,
    textTheme: TextTheme(
      body1: TextStyle(color: Colors.deepOrange.shade500, fontFamily: 'Orkney'),
      body2: const TextStyle(color: Colors.white, fontFamily: 'Orkney'),
      subhead: TextStyle(color: Colors.white, fontFamily: 'Orkney', fontWeight: FontWeight.bold),
      title: TextStyle(color: Colors.deepOrange.shade800, fontFamily: 'Orkney', /*fontWeight: FontWeight.bold*/),
    ),
    iconTheme: const IconThemeData(color: Colors.white),
    accentColor: Colors.yellow[500],
    pageTransitionsTheme: const PageTransitionsTheme(
        builders: <TargetPlatform, PageTransitionsBuilder>{
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder()
        }
    )
  );

  @override
  Widget build(BuildContext context) {
    return StoreProvider<AppState>(
      store: store,
      child: MaterialApp(
        builder: (BuildContext context, Widget child) {
          return ScrollConfiguration(
            behavior: MyScrollBehavior(),
            child: child,
          );
        },
        navigatorKey: navigatorKey,
        title: AppLocalizations.appTitle,
        localizationsDelegates: <AppLocalizationsDelegate>[
          AppLocalizationsDelegate(),
        ],
        theme: theme,
        routes: <String, Widget Function(BuildContext)>{
          AppRoutes.signIn: (BuildContext context) => const SignIn(),
          AppRoutes.signUp: (BuildContext context) => const SignUp(),
          AppRoutes.home: (BuildContext context) => const HomePage(),
          AppRoutes.favorite: (BuildContext context) => FavoritePage(),
          AppRoutes.profile: (BuildContext context) => const ProfilePage(),
          AppRoutes.addPlace: (BuildContext context) => NewPlace(),
          AppRoutes.place: (BuildContext context) => PlacePage(),
        },
        home: FutureBuilder<FirebaseUser>(
          future: FirebaseAuth.instance.currentUser(),
          builder: (BuildContext context, AsyncSnapshot<FirebaseUser> snapshot){
            switch (snapshot.connectionState){
              case ConnectionState.none:
              case ConnectionState.waiting:
                return const CircularProgressIndicator();
                break;
              default:
                if (snapshot.hasError)
                  return const SignIn();
                else {
                  if (snapshot.data == null)
                    return const SignIn();
                  else{
                    store.dispatch(SignInAction(snapshot.data, null, null, null));
                    return const HomePage();
                  }
                }
            }
          },
        ),
      ),
    );
  }
}

class MyScrollBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}