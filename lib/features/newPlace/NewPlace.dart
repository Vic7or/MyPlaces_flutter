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
            const SizedBox(width: 200, height: 200)
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
      return const SizedBox(width: 200, height: 220);
  }

  Widget _createButtonsWidget(BuildContext context, AddPlaceViewModel vm) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        MaterialButton(
          disabledColor: Colors.grey,
          onPressed: _storedImage != null && _position != null ? () => vm.validateNewPlace(_storedImage, _position, context) : null,
          child: Text('VALIDER', style: Theme.of(context).textTheme.subhead),
          color: Colors.green.shade800,
          splashColor: Theme.of(context).accentColor,
        ),
        MaterialButton(
          onPressed: () => setState((){
            _storedImage = null;
            _position = null;
          }),
          child: Text('RESET', style: Theme.of(context).textTheme.subhead),
          color: Theme.of(context).backgroundColor,
          splashColor: Theme.of(context).accentColor,
        )
      ],
    );
  }
}