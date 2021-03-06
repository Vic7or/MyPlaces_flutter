import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:myplaces/AppRoutes.dart';
import 'package:myplaces/features/viewmodels/HomeViewModel.dart';
import 'package:myplaces/features/viewmodels/ViewModel.dart';
import 'package:myplaces/model/MyPlacesUser.dart';
import 'package:myplaces/redux/Actions.dart';
import 'package:myplaces/redux/AppState.dart';
import 'package:redux/redux.dart';
import '../menu/MainMenu.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return HomePageState();
  }
}

class HomePageState extends State<HomePage> {

  MyPlacesUser data;
  ViewModel _vm;

  void update(){
    if (mounted)
      setState(() {
        data = _vm.store.state.mpUser;
      });
  }

  Widget createSeparator(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.5),
      width: MediaQuery.of(context).size.width,
      height: 1,
    );
  }

  Widget createDismissibleBackground(BuildContext context){
    return Container(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text('Supprimer', style: Theme.of(context).textTheme.subhead),
                  const SizedBox(width: 150, height: 0),
                  Icon(Icons.delete, color: Theme.of(context).primaryColorLight)
                ],
              ),
            ),
            createSeparator(context)
          ],
        ),
        color: Colors.red.shade800//Theme.of(context).primaryColorLight
    );
  }

  Future<bool> confirmDismiss(BuildContext context, DocumentReference userRef, DocumentReference placeRef) async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmation'),
          content: Text(
              'Voulez-vous vraiment supprimer cet élément ?',
              style: Theme.of(context).textTheme.body1
          ),
          actions: <Widget>[
            FlatButton(
              onPressed: () { 
                final DelPlaceAction action = DelPlaceAction(placeRef, userRef, context, update);
                _vm.store.dispatch(action);
                Navigator.of(context).pop(true);
              },
              child: Text(
                'supprimer',
                style: Theme.of(context).textTheme.title,
              )
            ),
        FlatButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(
                'annuler',
                style: Theme.of(context).textTheme.title,
              ),
            )
          ],
        );
      }
    );
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
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      IconButton(
                          icon: Icon(Icons.favorite, size: 40, color: Theme.of(context).primaryColorLight),
                          onPressed: () {
                            Navigator.of(context).pop();
                            final FavoriteAction action = FavoriteAction(placeRef, userRef, _context, update);
                            _vm.store.dispatch(action);
                          }
                      ),
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

  Widget _getBody(BuildContext context, HomeViewModel vm) {
    if (data != null)
      return ListView.separated(
          separatorBuilder: (BuildContext context, int index) => Divider(
            height: 0.0,
            color: Theme.of(context).primaryColorDark.withOpacity(0.5),
          ),
          itemCount: data.places.length,
          itemBuilder: (BuildContext context, int i){
            return Dismissible(
              confirmDismiss: (DismissDirection direction) => confirmDismiss(context, data.ref, data.places[i].ref),
              background: createDismissibleBackground(context),
              key: UniqueKey(),
              child:
              ListTile(
                onTap: () => vm.navigate(AppRoutes.place, <String, dynamic>{'place': data.places[i]}),
                onLongPress: () => longPressActionsDialog(context, data.ref, data.places[i].ref),
                title: Text(data.places[i].title, style: Theme.of(context).textTheme.subhead),
                subtitle: Container(
                  padding: const EdgeInsets.fromLTRB(5, 5, 0, 0),
                  child: Text(
                    vm.store.state.mpUser.places[i].description,
                    style: Theme.of(context).textTheme.body2,
                    overflow: TextOverflow.clip,
                    textAlign: TextAlign.start,
                    maxLines: 1,
                    softWrap: false,
                  ),
                ),
                leading: CircleAvatar(backgroundImage: NetworkImage(data.places[i].imageUrl),radius: 40,),
                trailing: const Icon(Icons.arrow_back_ios, color: Colors.white),
              ),
            );
          }
      );
    else {
      return const SizedBox(width: 0,height: 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
          builder: (BuildContext context) {
            return StoreConnector<AppState, ViewModel>(
              distinct: true,
              converter: (Store<AppState> store) => HomeViewModel.fromStore(store),
              builder: (BuildContext context, ViewModel vm){
                _vm = vm;
                if (data == null || data != vm.store.state.mpUser) {
                  final GetMPUserAction action = GetMPUserAction(update);
                  vm.store.dispatch(action);
                }
                return MainMenu(
                  Container(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: <Color>[
                            Theme.of(context).scaffoldBackgroundColor,
                            Theme.of(context).backgroundColor
                          ]
                        )
                    ),
                    //color: Theme.of(context).backgroundColor,
                    child: _getBody(context, vm),
                  )
                );
              },
            );
          }
      ),
    );
  }
}