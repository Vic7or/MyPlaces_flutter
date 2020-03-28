import 'package:myplaces/model/Place.dart';

class MyPlacesUser {
  MyPlacesUser(this.email, this.firstName, this.lastName, this.uid, this.places, this.favoris);
  String email;
  String firstName;
  String lastName;
  List<Place> places = <Place>[];
  List<Place> favoris = <Place>[];
  String uid;
}