import 'package:myplaces/AppRoutes.dart';
import 'package:redux/redux.dart';
import '../Actions.dart';

final Reducer<List<String>> navigationReducer = combineReducers<List<String>>(<List<String> Function(List<String>, dynamic)>[
  TypedReducer<List<String>, NavigateReplaceAction>(_navigateReplace),
  TypedReducer<List<String>, NavigatePushAction>(_navigatePush),
  TypedReducer<List<String>, NavigatePopAction>(_navigatePop),
  TypedReducer<List<String>, NavigateHomeStartUpAction>(_homeStartUp),
]);

List<String> _navigateReplace(List<String> route, NavigateReplaceAction action) => <String>[action.routeName];

List<String> _navigatePush(List<String> route, NavigatePushAction action) {
  final List<String> result = List<String>.from(route);
  result.add(action.routeName);
  return result;
}

List<String> _navigatePop(List<String> route, NavigatePopAction action) {
  final List<String> result = List<String>.from(route);
  result.removeLast();
  return result;
}

List<String> _homeStartUp(List<String> route, NavigateHomeStartUpAction action) => <String>[AppRoutes.home];