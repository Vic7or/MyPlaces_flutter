import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myplaces/features/viewmodels/AddPlaceViewModel.dart';
import 'package:myplaces/features/viewmodels/ViewModel.dart';
import 'package:myplaces/redux/AppState.dart';
import 'package:geolocator/geolocator.dart';

class NewPlace extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return NewPlaceState();
  }
}

class NewPlaceState extends State<NewPlace>{
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Completer<GoogleMapController> _controller = Completer<GoogleMapController>();
  final double _camBearing = 0.0;
  final double _camTilt = 0.0;
  final double _camZoom = 18;
  final Set<Marker> _markers = <Marker>{};
  BitmapDescriptor _pinLocationIcon;
  Position _position;
  File _storedImage;
  AddPlaceViewModel _vm;

  @override
  void initState() {
    super.initState();
    BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(devicePixelRatio: 2.5),
      'assets/images/pointeur_minilogo_map.png')
      .then((BitmapDescriptor bd) {
        _pinLocationIcon = bd;
      }
    );
  }

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
                    final Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
                    print(position);
                    setState(() {
                      _storedImage = image;
                      _position = position;
                    });
                  }
              ),
              padding: const EdgeInsets.only(bottom: 10)
          ),
          if (_storedImage != null)
            Container(
              width: 300,
              height: 200,
              decoration: BoxDecoration(
                  image: DecorationImage(image: FileImage(_storedImage), fit: BoxFit.cover)
              ),
            )
          else
            const SizedBox(width: 0, height: 0)
        ],
      ),
    );
  }

  Widget _getBody(BuildContext context, AddPlaceViewModel vm) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        _createPictureWidget(context, vm),
        _createLocalisationWidget(context),
        _createFormWidget(context, vm),
        _createButtonsWidget(context, vm)
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
              onPressed: () => _vm.navigate(null, null)
          ),
        ),
        body: Builder(
            builder: (BuildContext context) {
              return StoreConnector<AppState, ViewModel>(
                converter: (Store<AppState> store ) => AddPlaceViewModel.fromStore(store),
                builder: (BuildContext context, ViewModel vm) {
                  _vm = vm;
                  return SingleChildScrollView(child: _getBody(context, vm));
                },
              );
            }
        ),
      ),
      onWillPop: () async => false,
    );
  }

  Widget _createLocalisationWidget(BuildContext context) {
    if (_position != null) {
      final CameraPosition _cameraPosition = CameraPosition(
        target: LatLng(_position.latitude, _position.longitude),
        bearing: _camBearing,
        tilt: _camTilt,
        zoom: _camZoom,
      );
      return Container(
        margin: const EdgeInsets.only(top: 10, bottom: 10),
        width: 300,
        height: 200,
        child: GoogleMap(
          mapType: MapType.hybrid,
          initialCameraPosition: _cameraPosition,
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
            setState(() {
              _markers.add(
                  Marker(
                    markerId: MarkerId(UniqueKey().toString()),
                    position: _cameraPosition.target,
                    icon: _pinLocationIcon
                  )
              );
            });
          },
          myLocationEnabled: false,
          markers: _markers,
        ),
      );
    }
    else
      return const SizedBox(width: 0, height: 0);
  }

  Widget _createFormWidget(BuildContext context, AddPlaceViewModel vm) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          Padding(
              child: TextFormField(
                maxLength : 15,
                style: const TextStyle(color: Colors.white),
                maxLines: 1,
                obscureText: false,
                validator: (String value){
                  if (value.isEmpty) {
                    return 'Veuillez renseigner un titre';
                  }
                  return null;
                },
                onSaved: (String value) => vm.name = value,
                decoration: InputDecoration(
                    hintText: 'Titre',
                    hintStyle: Theme.of(context).textTheme.subhead,
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide: BorderSide(color: Theme.of(context).primaryColorLight)
                  ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide: BorderSide(color: Theme.of(context).backgroundColor)
                    ),
                ),
              ),
              padding: EdgeInsets.only(
                left: MediaQuery.of(context).size.width / 8,
                right: MediaQuery.of(context).size.width / 8,
                top: 10,
                bottom: 10
              )
          ),
          Padding(
              child: TextFormField(
                style: const TextStyle(color: Colors.white),
                maxLines: 4,
                obscureText: false,
                validator: (String value){
                  if (value.isEmpty) {
                    return 'Veuillez renseigner une description';
                  }
                  return null;
                },
                onSaved: (String value) => vm.description = value,
                decoration: InputDecoration(
                    hintText: 'Description',
                    hintStyle: Theme.of(context).textTheme.subhead,
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide: BorderSide(color: Theme.of(context).primaryColorLight)
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide: BorderSide(color: Theme.of(context).backgroundColor)
                    ),
                ),
              ),
              padding: EdgeInsets.only(
                left: MediaQuery.of(context).size.width / 8,
                right: MediaQuery.of(context).size.width / 8,
                bottom: 10
              )
          ),
        ],
      ),
    );
  }

  Widget _createButtonsWidget(BuildContext context, AddPlaceViewModel vm) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        MaterialButton(
          disabledColor: Colors.grey,
          onPressed: _storedImage != null && _position != null? () {
            if (_formKey.currentState.validate()){
              _formKey.currentState.save();
              final FocusScopeNode currentFocus = FocusScope.of(context);
              if (!currentFocus.hasPrimaryFocus)
                currentFocus.unfocus();
              vm.validateNewPlace(_storedImage, _position, context);
              /*
              setState((){
                _storedImage = null;
                _position = null;
                _formKey.currentState.reset();
              });
               */
            }
            else
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  duration: const Duration(seconds: 1),
                  backgroundColor: Theme.of(context).backgroundColor,
                  content: Text('Certains champs sont encore vides.', style: Theme.of(context).textTheme.body2)
                )
              );
          } : null,
          child: Text('VALIDER', style: Theme.of(context).textTheme.subhead),
          color: Colors.green.shade800,
          splashColor: Theme.of(context).accentColor,
        ),
        MaterialButton(
          onPressed: () => setState((){
            _storedImage = null;
            _position = null;
            _formKey.currentState.reset();
          }),
          child: Text('RESET', style: Theme.of(context).textTheme.subhead),
          color: Theme.of(context).backgroundColor,
          splashColor: Theme.of(context).accentColor,
        )
      ],
    );
  }
}