import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';

class Place {
  Place(this.imageUrl, this.position, this.title, this.description, this.ref);
  final String imageUrl;
  final Position position;
  final String title;
  final String description;
  final DocumentReference ref;
}

