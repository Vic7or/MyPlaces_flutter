import 'package:firebase_auth/firebase_auth.dart';
import 'package:myplaces/model/MyPlacesUser.dart';
import 'package:meta/meta.dart';

@immutable
class AppState {
 const AppState({
   this.isLoading = false,
   this.user,
   this.mpUser,
   this.route = const <String>[/*AppRoutes.home*/],
 });

 factory AppState.loading() => const AppState(isLoading: true);

 final bool isLoading;
 final FirebaseUser user;
 final MyPlacesUser mpUser;
 final List<String> route;

 AppState copyWith({bool isLoading}) => AppState(isLoading: isLoading ?? this.isLoading, route: route ?? route);

  @override
  String toString() {
    return 'AppState{isLoading: $isLoading, route: $route, user: $user, mpUser: $mpUser}';
  }
}
