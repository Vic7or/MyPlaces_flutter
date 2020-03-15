
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import '../../AppRoutes.dart';
import '../../redux/AppState.dart';
import '../viewmodels/MenuViewModel.dart';

class BottomNavBar extends StatelessWidget {

  Widget _addPadding(Widget child) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8),
    child: child,
  );

  Widget _getDisconnectItem(BuildContext context,
      {Icon icon, @required MenuViewModel vm}){
      return _addPadding(IconButton(icon: icon, onPressed: () => vm.disconnectPressed()));
  }

  Widget _getMenuItem(BuildContext context,
      {Icon icon, String routeName, @required MenuViewModel vm}) {
    if (!vm.route.contains(routeName))
      return _addPadding(
          IconButton(icon: icon, onPressed: () => vm.navigate(routeName)));
    else
      return _addPadding(IconButton(
          icon: icon,
          onPressed: () => vm.navigate(routeName),
          color: Theme.of(context).accentColor.withOpacity(0.7)));
  }

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      notchMargin: 8,
      color: Theme.of(context).primaryColor,
      shape: const CircularNotchedRectangle(),
      child: StoreConnector<AppState, MenuViewModel>(
        distinct: true,
        converter: (store) => MenuViewModel.fromStore(store),
        builder: (BuildContext context, MenuViewModel vm) => Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width / 2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                    _getMenuItem(context, icon: Icon(Icons.home), routeName: AppRoutes.home, vm: vm),
                    _getMenuItem(context, icon: Icon(Icons.favorite), routeName: AppRoutes.favorite, vm: vm),
                  ],
              ),
            ),

            /*
            _getMenuItem(context,
                icon: Icon(Icons.history),
                routeName: AppRoutes.history,
                vm: vm),
             */
            Container(
              width: MediaQuery.of(context).size.width / 2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  _getMenuItem(context, icon: Icon(Icons.person), routeName: AppRoutes.profile, vm: vm),
                  _getDisconnectItem(context, icon: Icon(Icons.power_settings_new), vm: vm)
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }
}


