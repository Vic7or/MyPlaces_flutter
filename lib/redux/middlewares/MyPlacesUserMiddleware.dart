import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:myplaces/model/MyPlacesUser.dart';
import 'package:redux/redux.dart';
import 'package:myplaces/model/Place.dart';
import '../Actions.dart';
import '../AppState.dart';

List<Middleware<AppState>> createMyPlacesUserMiddlewares() {
  return <Middleware<AppState>>[
    TypedMiddleware<AppState, GetMPUserAction>(_getMyPlaceUser),
  ];
}

Future<List<Place>> _getPlacesFromDocRef(List<dynamic> refList) async {
  final List<Place> ret = <Place>[];
  DocumentSnapshot docSnap;
  Map<String, dynamic> data;
  for (int i = 0; i < refList.length; ++i){
    docSnap = await refList[i].get();
    data = docSnap.data;
    final Place place = Place(
      data['imageUrl'],
      Position(longitude: data['location']['lng'], latitude: data['location']['lat']),
      data['title'],
      data['description'],
      docSnap.reference
    );
    ret.add(place);
  }
  return ret;
}

Future<void> _getMyPlaceUser(Store<AppState> store, GetMPUserAction action, NextDispatcher next) async {
  final Firestore _fireStore = Firestore.instance;
  _fireStore.collection('users').where('uid', isEqualTo: store.state.user.uid).getDocuments()
      .then((QuerySnapshot querySnap) async {
        final DocumentSnapshot docSnap =  querySnap.documents.first;
        final Map<String, dynamic> data = docSnap.data;
        final List<Place>  places = await _getPlacesFromDocRef(data['places']);
        final List<Place>  favoris = await _getPlacesFromDocRef(data['favoris']);
        final MyPlacesUser mpUser = MyPlacesUser(
          data['email'],
          data['firstName'],
          data['lastName'],
          data['uid'],
          places,
          favoris,
          docSnap.reference
        );
        action.user = mpUser;
        next(action);
        if (action.update != null)
          action.update();
  });
}