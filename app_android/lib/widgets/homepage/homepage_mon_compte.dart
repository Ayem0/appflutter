import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '/screens/sign_in_page_screen.dart';
import '/utils/authentication.dart';
import '/screens/launchingpage_screen.dart';

class homepageMoncompte extends StatefulWidget {
  const homepageMoncompte({Key? key, required User user})
      : _user = user,
        super(key: key);

  final User _user;
  @override
  State<homepageMoncompte> createState() => _homepageMoncompteState();
}

class _homepageMoncompteState extends State<homepageMoncompte> {
  bool buttonsVisible = false;
    late User _user;
  bool _isSigningOut = false;

  Route _routeToSignInScreen() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => SignInPageScreen(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(-1.0, 0.0);
        var end = Offset.zero;
        var curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  Future<void> _showConfirmationDialog(
      BuildContext context, Function setState) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Êtes-vous sûr(e) de vouloir vous déconnecter ?'),
          actions: <Widget>[
            TextButton(
              child: Text('Non'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Oui'),
              onPressed: () async {
                setState(() {
                  _isSigningOut = true;
                });
                await FirebaseAuth.instance.signOut();
                setState(() {
                  _isSigningOut = false;
                });
                Navigator.of(context).pushReplacement(_routeToSignInScreen());
              },
            ),
          ],
        );
      },
    );
  }

  @override
   void initState() {
    _user = widget._user;
    super.initState();
  }

  @override

  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(top: 45.0, bottom: 16),
            alignment: Alignment.topCenter,
            color: Colors.white,
            child: Text(
              'Mon compte',
              style: TextStyle(
                fontSize: 30.0,
                color: Colors.black,
              ),
            ),
          ),
          TextButton.icon(
            onPressed: () {},
            icon: Icon(
              Icons.settings,
              color: Colors.black,
            ),
            label: Text('Paramètres du compte',
                style: TextStyle(color: Colors.black)),
            style: ElevatedButton.styleFrom(
              side: BorderSide(
                color: Colors.transparent,
                width: 0.0,
              ),
            ),
          ),
          TextButton.icon(
            onPressed: () {},
            icon: Icon(
              Icons.history,
              color: Colors.black,
            ),
            label: Text(
              'Historique des commandes',
              style: TextStyle(color: Colors.black),
            ),
            style: ElevatedButton.styleFrom(
              side: BorderSide(
                color: buttonsVisible ? Colors.black : Colors.transparent,
                width: 0.0,
              ),
            ),
          ),
          TextButton.icon(
            onPressed: () {
              // Logique pour "Conditions générales"
            },
            icon: Icon(
              Icons.info,
              color: Colors.black,
            ),
            label: Text(
              'Conditions générales',
              style: TextStyle(color: Colors.black),
            ),
            style: ElevatedButton.styleFrom(
              side: BorderSide(
                color: buttonsVisible ? Colors.black : Colors.transparent,
                width: 1.0,
              ),
            ),
          ),
          TextButton.icon(
            onPressed: () {
              _showConfirmationDialog(context, setState);
            },
            icon: Icon(
              Icons.logout,
              color: Colors.black,
            ),
            label: Text('Déconnexion', style: TextStyle(color: Colors.black)),
            style: ElevatedButton.styleFrom(
                side: BorderSide(
              color: buttonsVisible ? Colors.black : Colors.transparent,
              width: 1.0,
            )),
          ),
        ],
      ),
    );
  }
}