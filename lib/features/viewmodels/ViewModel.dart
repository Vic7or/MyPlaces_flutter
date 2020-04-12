import 'package:redux/redux.dart';
import '../../redux/AppState.dart';

abstract class ViewModel {
  List<String> route;
  Function(String, Map<String, dynamic>) navigate;
  Store<AppState> store;
  @override
  bool operator ==(Object other) {
    return identical(this, other)
        || (other is ViewModel && runtimeType == other.runtimeType && route == other.route);
  }
  @override
  int get hashCode => route.hashCode;
}