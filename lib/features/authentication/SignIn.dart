import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:myplaces/AppRoutes.dart';
import 'package:redux/redux.dart';
import '../../redux/AppState.dart';
import '../viewmodels/AuthViewModel.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key key}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  _SignInState();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: true,
      body: Builder(
        builder: (BuildContext context) {
          return StoreConnector<AppState, AuthViewModel>(
            distinct: true,
            converter: (Store<AppState> store) => AuthViewModel.fromStore(store),
            builder: (BuildContext context, AuthViewModel vm) {
              return InkWell(
                  onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
                  child: SingleChildScrollView(
                    child: Container(
                      height: MediaQuery.of(context).size.height,
                      decoration: const BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage('assets/images/fireTower.jpg'),
                              fit: BoxFit.cover
                          )
                      ),
                      child: Center(
                        child: Column(
                          children: <Widget>[
                            Padding(
                              child: Image.asset('assets/images/Logo_MP.png', width:110, height: 110),
                              padding: const EdgeInsets.only(top: 50, bottom: 15),
                            ),
                            Text(
                              'Connexion',
                              maxLines: 1,
                              style: TextStyle(
                                color: Colors.deepOrange.shade500,
                                fontFamily: 'Orkney',
                                fontWeight: FontWeight.bold,
                                fontSize: 35,
                                //fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: MediaQuery.of(context).size.height / 8.5),
                            createFormContainer(context, vm)
                          ],
                        ),
                      ),
                    ),
                  )
              );
            },
          );
        }
      ),
    );
  }

  Widget createFormContainer(BuildContext context, AuthViewModel vm){
    final Container formContainer = Container(
      //color: Colors.white,
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height / 1.8,
      child: Theme(
          data: ThemeData(
              hintColor: Colors.white70
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Padding(
                    child: TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        style: const TextStyle(color: Colors.white),
                        maxLines: 1,
                        validator: (String value){
                          if (value.isEmpty) {
                            return 'Veuillez saisir une adresse email valide';
                          }
                          final bool emailValid =
                          RegExp(r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+')
                              .hasMatch(value);
                          if (!emailValid) {
                            return 'Email invalide';
                          }
                          return null;
                        },
                        onSaved: (String value) => vm.email = value,
                        decoration: InputDecoration(
                            hintText: 'Adresse email',
                            labelStyle: const TextStyle(fontFamily: 'Orkney'),
                            hintStyle: TextStyle(
                              color: Colors.deepOrange.shade500,
                              fontFamily: 'Orkney',
                              fontWeight: FontWeight.bold
                            ),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.0),
                                borderSide: BorderSide(color: Colors.deepOrange.shade500)
                            ),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.0),
                                borderSide: const BorderSide()
                            ),
                            icon: Padding(
                                child: Icon(Icons.mail, size: 30, color: Colors.deepOrange.shade500),
                                padding: const EdgeInsets.only(top: 5)
                            )
                        )
                    ),
                    padding: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width / 8,
                        right: MediaQuery.of(context).size.width / 8
                    )
                ),
                Padding(
                    child: TextFormField(
                      style: const TextStyle(color: Colors.white),
                      maxLines: 1,
                      obscureText: true,
                      validator: (String value){
                        if (value.isEmpty) {
                          return 'Veuillez saisir un mot de passe';
                        }
                        return null;
                      },
                      onSaved: (String value) => vm.password = value,
                      decoration: InputDecoration(
                          hintText: 'Mot de passe',
                          hintStyle: TextStyle(
                            fontFamily: 'Orkney',
                            fontWeight: FontWeight.bold,
                            color: Colors.deepOrange.shade500
                          ),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25.0),
                              borderSide: BorderSide(color: Colors.deepOrange.shade500)
                          ),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25.0),
                              borderSide: const BorderSide()
                          ),
                          icon: Padding(
                              child: Icon(Icons.vpn_key, size: 30, color: Colors.deepOrange.shade500),
                              padding: const EdgeInsets.only(top: 5)
                          )
                      ),
                    ),
                    padding: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width / 8,
                        right: MediaQuery.of(context).size.width / 8
                    )
                ),
                MaterialButton(
                      child: Text(
                        'CONNEXION',
                        maxLines: 1,
                        style: TextStyle(
                            color: Colors.deepOrange.shade500,
                            fontFamily: 'Orkney'
                        ),
                      ),
                      onPressed: () => vm.signInPressed(_formKey, context)
                  ),
                MaterialButton(
                    child: Text(
                      'Pas encore de compte?',
                      maxLines: 1,
                      style: TextStyle(
                          color: Colors.deepOrange.shade500,
                          fontFamily: 'Orkney'
                      ),
                    ),
                    onPressed: () => vm.navigate(AppRoutes.signUp, null)
                ),
              ],
            ),
          )
      ),
    );
    return formContainer;
  }
}