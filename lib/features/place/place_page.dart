import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:myplaces/features/viewmodels/AddPlaceViewModel.dart';
import 'package:myplaces/features/viewmodels/ViewModel.dart';
import 'package:myplaces/model/Place.dart';
import 'package:myplaces/redux/AppState.dart';
import 'package:redux/redux.dart';

class PlacePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> args = ModalRoute.of(context).settings.arguments;
    final Place place = args['place'];
    ViewModel _vm;
    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          title: Text(place.title, style: Theme.of(context).textTheme.subhead),
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => _vm.navigate(null, null)
          ),
        ),
        body: Builder(
            builder: (BuildContext context) {
              return StoreConnector<AppState, ViewModel>(
                converter: (Store<AppState> store ) => AddPlaceViewModel.fromStore(store),
                builder: (BuildContext context, ViewModel vm) {
                  _vm = vm;
                  return _getBody(context, place, vm);
                },
              );
            }
        ),
      ),
      onWillPop: () async => false,
    );
  }

  Widget _getBody(BuildContext context, Place place, ViewModel vm) {
    return Center(
      child: Text(place.description),
    );
  }
}