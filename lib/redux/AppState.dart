import 'package:firebase_auth/firebase_auth.dart';
import 'package:myplaces/model/Place.dart';
import 'package:meta/meta.dart';

const Place mock = Place(
    'https://firebasestorage.googleapis.com/v0/b/myplaces-70bb2.appspot.com/o/7Dq5pSKm8YTCn8t6dyVM2IeRiTI3%2F1%E2%80%AF573%E2%80%AF991%E2%80%AF114%E2%80%AF410?alt=media&token=a33561d8-e89b-4486-b225-daf165a49085',
    'My Place',
    'A place we will never forget');

@immutable
class AppState {
 const AppState({
  this.isLoading = false,
  this.user = null,
   this.places = const <Place>[mock, mock, mock, mock, mock, mock, mock, mock, mock, mock, mock, mock, mock, mock, mock, mock],
  this.route = const <String>[/*AppRoutes.home*/],
});

 factory AppState.loading() => const AppState(isLoading: true);

 final bool isLoading;
final FirebaseUser user;
final List<String> route;
final List<Place> places;

AppState copyWith({
  bool isLoading
}) =>

    AppState(
  isLoading: isLoading ?? this.isLoading,
  route: route ?? route
);



  @override
  String toString() {
    return 'AppState{isLoading: $isLoading, route: $route, user: $user}';
  }
}
