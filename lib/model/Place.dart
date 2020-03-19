import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Place {
  const Place(this.imageUrl, this.title, this.subtitle);
  final String imageUrl;
  final String title;
  final String subtitle;
  final Icon icon = const Icon(Icons.arrow_back_ios, color: Colors.white);
}

