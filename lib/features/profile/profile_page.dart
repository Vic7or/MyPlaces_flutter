
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:myplaces/features/viewmodels/ProfileViewModel.dart';
import 'package:myplaces/features/viewmodels/ViewModel.dart';
import 'package:myplaces/redux/AppState.dart';
import 'package:redux/redux.dart';
import '../../commons/InfoCard.dart';
import '../menu/MainMenu.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key key}) : super(key: key);

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
                    image: const DecorationImage(
                        image: /* imagePickerFile != null
                            ? Image.file(imagePickerFile).image
                            :  */NetworkImage('https://gyazo.com/21dc9e7aa1af42d4d57fcc9f2cb0527d'),
                        fit: BoxFit.cover),
                    borderRadius: const BorderRadius.all(Radius.circular(45.0)),
                    boxShadow: <BoxShadow>[BoxShadow(blurRadius: 7.0, color: Colors.black)]),
              ),
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
            const SizedBox(
              height: 20,
              width: 200,
              child: Divider(
                color: Colors.white,
              ),
            ),
            InfoCard(
              text: vm.store.state.user.email,
              icon: Icons.email,
              onPressed: null,
            ),
            InfoCard(
              text: 'J aime lyon',
              icon: Icons.favorite,
              onPressed: null,
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
