import 'dart:io';
import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myplaces/features/viewmodels/AddPlaceViewModel.dart';
import 'package:myplaces/features/viewmodels/ViewModel.dart';
import 'package:myplaces/redux/AppState.dart';

class NewPlace extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return NewPlaceState();
  }
}

class NewPlaceState extends State<NewPlace>{
  File _storedImage;
  AddPlaceViewModel _vm;

  Widget _createPictureWidget(BuildContext context, AddPlaceViewModel vm) {
    return Container(
      alignment: Alignment.topCenter,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
              child: Text('Prenez la photo d\'un lieu :', style: Theme.of(context).textTheme.subhead),
              padding: const EdgeInsets.only(top: 10, bottom: 10)
          ),
          Padding(
              child: FloatingActionButton(
                  backgroundColor: Theme.of(context).accentColor.withOpacity(0.7),
                  child: Icon(Icons.photo_camera, color: Theme.of(context).primaryColorLight),
                  onPressed: () async {
                    final File image = await ImagePicker.pickImage(source: ImageSource.camera);
                    setState(() {
                      _storedImage = image;
                    });
                  }
              ),
              padding: const EdgeInsets.only(bottom: 10)
          ),
          _storedImage != null ?
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              color: Colors.green,
              image: DecorationImage(image: FileImage(_storedImage), fit: BoxFit.cover)
            ),
          )
          : SizedBox(width: 200, height: 200)
        ],
      ),
    );
  }

  Widget _getBody(BuildContext context, AddPlaceViewModel vm) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        _createPictureWidget(context, vm)
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Add Place', style: Theme.of(context).textTheme.subhead),
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => _vm.navigate(null)
          ),
        ),
        body: Builder(
            builder: (BuildContext context) {
              return StoreConnector<AppState, ViewModel>(
                converter: (Store<AppState> store ) => AddPlaceViewModel.fromStore(store),
                builder: (BuildContext context, ViewModel vm) {
                  _vm = vm;
                  return _getBody(context, vm);
                },
              );
            }
        ),
      ),
      onWillPop: () async => false,
    );
  }
}