import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import '../../AppRoutes.dart';
import '../../features/menu/BottomNavBar.dart';
import '../../redux/Actions.dart';
import '../../redux/AppState.dart';

class MainMenu extends StatelessWidget {
  const MainMenu(this.body);
  final Widget body;

  Widget _getInfoBarWorkaround() =>
      PreferredSize(child: Container(), preferredSize: const Size(0.0, 0.0));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: _getInfoBarWorkaround(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomNavBar(),
      floatingActionButton: FloatingActionButton(
        foregroundColor: Colors.white,
        backgroundColor: Theme.of(context).accentColor.withOpacity(0.7),
        onPressed: () => StoreProvider.of<AppState>(context)
            .dispatch(NavigatePushAction(AppRoutes.addPlace, null)),
        tooltip: 'Take a new place',
        child: Icon(Icons.add_a_photo),
      ),
      body: body,
    );
  }
}
