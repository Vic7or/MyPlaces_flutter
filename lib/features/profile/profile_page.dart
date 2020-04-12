
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myplaces/features/viewmodels/ProfileViewModel.dart';
import 'package:myplaces/features/viewmodels/ViewModel.dart';
import 'package:myplaces/model/MyPlacesUser.dart';
import 'package:myplaces/redux/AppState.dart';
import 'package:redux/redux.dart';
import '../../commons/InfoCard.dart';
import '../menu/MainMenu.dart';

class ProfilePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ProfilePageState();
  }
}

class ProfilePageState extends State<ProfilePage> {

  MyPlacesUser data;
  File imageFile;
  ViewModel _vm;
  BuildContext _context;

  void update(){
    if (mounted)
      setState(() {
        imageFile = null;
        data = _vm.store.state.mpUser;
      });
  }

  @override
  void initState(){
    super.initState();
  }

  Widget _test(ProfileViewModel vm) {
    return SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 150,
              height: 150,
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.red,
                    image: DecorationImage(
                        image: (data != null && data.profilePicture != null) ?
                        NetworkImage(data.profilePicture) :
                        Image.asset('assets/images/placeholder.png').image,
                        fit: BoxFit.cover),
                    borderRadius: const BorderRadius.all(Radius.circular(45.0)),
                    boxShadow: <BoxShadow>[BoxShadow(blurRadius: 7.0, color: Colors.black)]),
              ),
            ),
            FloatingActionButton(
                backgroundColor: Theme.of(context).accentColor.withOpacity(0.7),
                heroTag: null,
                child: Icon(Icons.photo_camera, color: Theme.of(context).primaryColorLight),
                onPressed: () async {
                  final File image = await ImagePicker.pickImage(source: ImageSource.gallery);
                  vm.uploadPicture(image, _context, update);
                  setState(() {
                    imageFile = image;
                  });
                }
            ),
            Text(
              data != null ? data.firstName+' '+data.lastName : vm.store.state.mpUser.firstName+' '+vm.store.state.mpUser.lastName,
              style: TextStyle(
                fontSize: 40.0,
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontFamily: 'Pacifico',
              ),
            ),
            SizedBox(
              height: 20,
              width: 200,
              child: Divider(
                color: Colors.white,
              ),
            ),
            InfoCard(
              text: data != null ? data.email : vm.store.state.user.email,
              icon: Icons.email,
              onPressed: null,
            ),
            InfoCard(
              text: data != null ? data.uid : vm.store.state.user.uid,
              icon: Icons.vpn_key,
              onPressed: null,
            ),
          ],
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (BuildContext context) {
          return StoreConnector<AppState, ViewModel>(
            distinct: true,
            converter: (Store<AppState> store) => ProfileViewModel.fromStore(store),
            builder: (BuildContext context, ViewModel vm) {
              _context = context;
              _vm = vm;
              return MainMenu(_test(vm));
            },
          );
        }
      ),
    );
  }
}
