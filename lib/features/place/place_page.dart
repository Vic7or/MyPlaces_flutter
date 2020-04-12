import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:myplaces/features/viewmodels/AddPlaceViewModel.dart';
import 'package:myplaces/features/viewmodels/ViewModel.dart';
import 'package:myplaces/model/Place.dart';
import 'package:myplaces/redux/AppState.dart';
import 'package:redux/redux.dart';
import 'package:url_launcher/url_launcher.dart';

class PlacePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> args = ModalRoute.of(context).settings.arguments;
    final Place place = args['place'];
    ViewModel _vm;
    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          title: Text(place.title,
              style: TextStyle(
                fontSize: 25.0,
                color: Colors.black87,
              )),
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => _vm.navigate(null, null)),
        ),
        body: Builder(builder: (BuildContext context) {
          return StoreConnector<AppState, ViewModel>(
            converter: (Store<AppState> store) =>
                AddPlaceViewModel.fromStore(store),
            builder: (BuildContext context, ViewModel vm) {
              _vm = vm;
              return _getBody(context, place, vm);
            },
          );
        }),
      ),
      onWillPop: () async => false,
    );
  }

  Widget _getBody(BuildContext context, Place place, ViewModel vm) {
    final String latitude = place.position.latitude.toString();
    final String longitude = place.position.longitude.toString();
    final String url = 'https://www.google.com/maps/search/?api=1&query=' +
        latitude +
        ',' +
        longitude;
    return Padding(
        padding: const EdgeInsets.fromLTRB(5, 0, 5, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Center(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 24.0, 0.0, 0.0),
                child: Image.network(
                  place.imageUrl,
                  height: MediaQuery.of(context).size.height / 2.5,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 5, 0.0, 0.0),
                child: SingleChildScrollView(
                  child: Text(
                    place.description,
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
              child: InkWell(
                onTap: () => launch(url),
                child: Text(
                  'Lien location',
                  style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.blue,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
          // child: Text(place.description),
          // );
        ));
  }

}
