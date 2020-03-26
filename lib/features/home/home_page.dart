import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:myplaces/AppRoutes.dart';
import 'package:myplaces/features/viewmodels/AuthViewModel.dart';
import 'package:myplaces/features/viewmodels/HomeViewModel.dart';
import 'package:myplaces/features/viewmodels/ViewModel.dart';
import 'package:myplaces/redux/AppState.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import '../menu/MainMenu.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key key}) : super(key: key);

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

  Future<bool> confirmDismiss(BuildContext context) async {
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
              onPressed: () => Navigator.of(context).pop(true),
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

  void longPressActionsDialog(BuildContext _context) {
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
                          icon: Icon(Icons.favorite, size: 40, color: Theme.of(context).primaryColorLight),
                          onPressed: () {
                            Navigator.of(context).pop();
                            Scaffold.of(_context).showSnackBar(
                                const SnackBar(
                                  content: Text('Ajouté aux favoris'),
                                  duration: Duration(seconds: 1),
                                )
                            );
                          }
                      ),
                      Text('FAVORIS', style: Theme.of(context).textTheme.subhead)
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
          builder: (BuildContext context) {
            return StoreConnector<AppState, ViewModel>(
              distinct: true,
              converter: (Store<AppState> store) => HomeViewModel.fromStore(store),
              builder: (BuildContext context, ViewModel vm){
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
                    child: ListView.separated(
                        separatorBuilder: (BuildContext context, int index) => Divider(
                          height: 0.0,
                          color: Theme.of(context).primaryColorDark.withOpacity(0.5),
                        ),
                        itemCount: vm.store.state.places.length,
                        itemBuilder: (BuildContext context, int i){
                          return Dismissible(
                            confirmDismiss: (DismissDirection direction) => confirmDismiss(context),
                            background: createDismissibleBackground(context),
                            key: UniqueKey(),
                            child:
                            ListTile(
                              onTap: () => vm.navigate(AppRoutes.favorite),
                              onLongPress: () => longPressActionsDialog(context),
                              title: Text(vm.store.state.places[i].title, style: Theme.of(context).textTheme.subhead),
                              subtitle: Text(vm.store.state.places[i].description, style: Theme.of(context).textTheme.body2),
                              leading: CircleAvatar(backgroundImage: NetworkImage(vm.store.state.places[i].imageUrl)),
                              trailing: const Icon(Icons.arrow_back_ios, color: Colors.white),
                            ),
                          );
                        }
                    ),
                  )
                );
              },
            );
          }
      ),
    );
  }
}