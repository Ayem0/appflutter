import 'package:app_android/screens/register_pro_screen.dart';
import 'package:app_android/screens/homepageSeller_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '/screens/sign_in_page_screen.dart';
import 'package:google_sign_in/google_sign_in.dart';

class homepageMoncompte extends StatefulWidget {
  const homepageMoncompte({
    Key? key,
    required User user,
    required String address,
    required double latitude,
    required double longitude,
    required String city,
    required String country,
  })  : _user = user,
        _address = address,
        _latitude = latitude,
        _longitude = longitude,
        _city = city,
        _country = country,
        super(key: key);

  final User _user;
  final String _address;
  final double _latitude;
  final double _longitude;
  final String _city;
  final String _country;
  @override
  State<homepageMoncompte> createState() => _homepageMoncompteState();
}

class _homepageMoncompteState extends State<homepageMoncompte> {
  bool buttonsVisible = false;
  late User _user;
  String _address = ''; // Ajoutez les autres champs nécessaires
  double _latitude = 0.0;
  double _longitude = 0.0;
  String _city = '';
  String _country = '';
  bool isSeller = false;

  Route _routeToSignInScreen() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          SignInPageScreen(),
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

  Future<bool> isUserSeller(String userId) async {
    try {
      // Récupère le document utilisateur
      DocumentSnapshot userDocument = await FirebaseFirestore.instance
          .collection('utilisateurs')
          .doc(userId)
          .get();

      // Vérifie si le document existe et si la propriété isSeller est vraie
      if (userDocument.exists) {
        bool res = userDocument.get('isSeller');
        setState(() {
          isSeller = res;
        });
        if (isSeller == true) {
          return true;
        } else {
          return false;
        }
      } else {
        return false;
      }
    } catch (e) {
      print('Erreur lors de la vérification du statut de vendeur : $e');
      return false;
    }
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
                await GoogleSignIn().signOut();
                await FirebaseAuth.instance.signOut();

                Navigator.of(context).pushReplacement(_routeToSignInScreen());
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> loadIsSellerStatus() async {
    bool result = await isUserSeller(_user.uid);
    setState(() {
      isSeller = result;
    });
    print(isSeller);
  }

  @override
  void initState() {
    _user = widget._user;
    _address = widget._address;
    _latitude = widget._latitude;
    _longitude = widget._longitude;
    _city = widget._city;
    _country = widget._country;
    loadIsSellerStatus();
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
          Icon(
            Icons.account_box_rounded,
            size: 120,
          ),
          Text(_user.displayName.toString()),
          SizedBox(
            height: 20,
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
          if (isSeller)
            TextButton.icon(
              onPressed: () {
                // envoie vers l'homepage vendeur
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SellerHomepageScreen(
                      user: widget._user,
                    ),
                  ),
                );
              },
              icon: Icon(
                Icons.store,
                color: Colors.black,
              ),
              label: Text(
                "Accéder à l'interface vendeur",
                style: TextStyle(color: Colors.black),
              ),
              style: ElevatedButton.styleFrom(
                side: BorderSide(
                  color: buttonsVisible ? Colors.black : Colors.transparent,
                  width: 0.0,
                ),
              ),
            ),
          if (!isSeller) // Si l'utilisateur n'est pas un vendeur
            TextButton.icon(
              onPressed: () {
                // Logique pour enregistrer le commerce
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RegisterProScreen(
                      user: widget._user,
                      address: _address,
                      city: _city,
                      latitude: _latitude,
                      longitude: _longitude,
                      country: _country,
                    ),
                  ),
                );
              },
              icon: Icon(
                Icons.store,
                color: Colors.black,
              ),
              label: Text(
                'Enregistrer mon commerce',
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
