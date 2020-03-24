
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myplaces/features/viewmodels/ProfileViewModel.dart';
import 'package:myplaces/features/viewmodels/ViewModel.dart';
import 'package:myplaces/redux/AppState.dart';
import 'package:redux/redux.dart';
import '../../commons/InfoCard.dart';
import '../menu/MainMenu.dart';

class ProfilePage extends StatefulWidget {
 @override
  State<StatefulWidget> createState(){
    return ProfilePageState();
  }
}




class ProfilePageState extends State<ProfilePage> {
  File _storedImage;

  Widget _test(ViewModel vm) {
        return Scaffold(
          body: SafeArea(
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
                      image: _storedImage != null
                      ? Image.file(_storedImage).image
                      : const NetworkImage('https://gyazo.com/e20087e512be43865d9f25b82ec2bb18'),
                      fit: BoxFit.cover),
                     borderRadius: const BorderRadius.all(Radius.circular(45.0)),
                      boxShadow: [BoxShadow(blurRadius: 7.0, color: Colors.black)]),
                  ),
                ),
                FloatingActionButton(
                  backgroundColor: Theme.of(context).accentColor.withOpacity(0.7),
                  child: Icon(Icons.photo_camera, color: Theme.of(context).primaryColorLight),
                  onPressed: () async {
                    final File image = await ImagePicker.pickImage(source: ImageSource.gallery);
                    setState(() {
                      _storedImage = image;
                    });
                  }
                ),                
                Text(
                  'Lucas Courneil',
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
                  text: vm.store.state.user.email,
                  icon: Icons.email,
                ),
                InfoCard(
                  text: 'J aime lyon',
                  icon: Icons.favorite,
                ),
          ],
        ),
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
              return MainMenu(_test(vm));
            },
          );
        }
      ),
    );
  }
}
