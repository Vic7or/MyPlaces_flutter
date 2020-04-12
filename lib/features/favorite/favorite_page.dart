import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:myplaces/features/viewmodels/AuthViewModel.dart';
import 'package:myplaces/features/viewmodels/ViewModel.dart';
import 'package:myplaces/model/MyPlacesUser.dart';
import 'package:myplaces/redux/Actions.dart';
import 'package:myplaces/redux/AppState.dart';
import 'package:redux/redux.dart';
import 'package:myplaces/AppRoutes.dart';
import '../menu/MainMenu.dart';

class FavoritePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return FavoritePageState();
  }
}

class FavoritePageState extends State<FavoritePage> {

  MyPlacesUser data;
  ViewModel _vm;

  void update(){
    if (mounted)
      setState(() {
        data = _vm.store.state.mpUser;
      });
  }

  void longPressActionsDialog(BuildContext _context, DocumentReference userRef, DocumentReference placeRef) {
    showDialog<dynamic>(
        context: _context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.transparent,
            elevation: 0,
            content: Container(
              height: MediaQuery.of(context).size.height / 8,
              decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: const BorderRadius.all(Radius.circular(20))
              ),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        IconButton(
                            icon: Icon(Icons.share, size: 40, color: Theme.of(context).primaryColorLight),
                            onPressed: () {
                              Navigator.of(context).pop();
                              Scaffold.of(_context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Place partagée'),
                                    duration: Duration(seconds: 1),
                                  )
                              );
                            }
                        ),
                        Text('PARTAGER', style: Theme.of(context).textTheme.subhead)
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        IconButton(
                            icon: Icon(Icons.favorite_border, size: 40, color: Theme.of(context).primaryColorLight),
                            onPressed: () {
                              Navigator.of(context).pop();
                              final UnFavoriteAction action = UnFavoriteAction(placeRef, userRef, _context, update);
                              _vm.store.dispatch(action);
                            }
                        ),
                        Text('RETIRER FAVORIS', style: Theme.of(context).textTheme.subhead)
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        }
    );
  }

  Widget _getBody(BuildContext context, ViewModel vm) {
    if (data != null){
      return ListView.separated(
        itemCount: data.favoris.length,
        itemBuilder: (BuildContext context, int i) {
          return ListTile(
            onTap: () => vm.navigate(AppRoutes.place, <String, dynamic>{'place': data.favoris[i]}),
            onLongPress: () => longPressActionsDialog(context, data.ref, data.favoris[i].ref),
            title: Text(data.favoris[i].title, style: Theme.of(context).textTheme.subhead),
            subtitle: Text(data.favoris[i].description, style: Theme.of(context).textTheme.body2),
            leading: CircleAvatar(backgroundImage: NetworkImage(data.favoris[i].imageUrl)),
            trailing: const Icon(Icons.arrow_back_ios, color: Colors.white),
          );
        },
        separatorBuilder: (BuildContext context, int index) => Divider(
          height: 0.0,
          color: Theme.of(context).primaryColorDark.withOpacity(0.5),
        ),
      );
    }
    else
      return const SizedBox(width: 0, height: 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (BuildContext context) {
          return StoreConnector<AppState, ViewModel>(
            distinct: true,
            converter: (Store<AppState> store) => AuthViewModel.fromStore(store),
            builder: (BuildContext context, ViewModel vm) {
              _vm = vm;
              if (data == null || data != vm.store.state.mpUser) {
                final GetMPUserAction action = GetMPUserAction(update);
                vm.store.dispatch(action);
              }
              return MainMenu(_getBody(context, vm));
            },
          );
        }
      ),
    );
  }
}
