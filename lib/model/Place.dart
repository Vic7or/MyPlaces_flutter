import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class Place {
  Place(this.imageUrl, this.position, this.title, this.description);
  final String imageUrl;
  final Position position;
  final String title;
  final String description;
}

