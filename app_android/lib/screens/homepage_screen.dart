import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '/widgets/homepage/homepage_mon_compte.dart';
import '/widgets/homepage/homepage_parcourir.dart';
import '/widgets/homepage/homepage_accueil.dart';

class HomepageScreen extends StatefulWidget {
  const HomepageScreen({
    Key? key,
    required User user,
    required String address,
    required double latitude,
    required double longitude,
    required String city,
  })  : _user = user,
        _address = address,
        _latitude = latitude,
        _longitude = longitude,
        _city = city,
        super(key: key);

  final User _user;
  final String _address;
  final double _latitude;
  final double _longitude;
  final String _city;
  @override
  State<HomepageScreen> createState() => _HomepageScreenState();
}

class _HomepageScreenState extends State<HomepageScreen> {
  int _currentIndex = 0;
  late User _user;

  @override

   void initState() {
    _user = widget._user;
    super.initState();
  }
  @override

  Widget build(BuildContext context) {
    Widget content;
    switch (_currentIndex) {
      case 0:
        content = homepageAccueil(user: _user, longitude: widget._longitude, latitude: widget._latitude, city: widget._city, address: widget._address,);
        break;
      case 1:
        content = homepageParcourir(user: _user,longitude: widget._longitude, latitude: widget._latitude, city: widget._city, address: widget._address,);
        break;
      case 2:
        content = homepageMoncompte(user: _user,longitude: widget._longitude, latitude: widget._latitude, city: widget._city, address: widget._address,);
        break;
      default:
        content = homepageAccueil(user: _user,longitude: widget._longitude, latitude: widget._latitude, city: widget._city, address: widget._address,);
    }

    return Scaffold(
      body: content,
      bottomNavigationBar: BottomNavigationBar(
        unselectedLabelStyle: const TextStyle(
            color: Color.fromARGB(255, 32, 32, 32), fontSize: 14),
        selectedLabelStyle: const TextStyle(
            color: Color.fromARGB(255, 32, 32, 32), fontSize: 14),
        selectedItemColor: Color.fromARGB(255, 32, 32, 32),
        backgroundColor: Colors.white,
        unselectedItemColor: Color.fromARGB(255, 32, 32, 32),
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Color.fromARGB(255, 32, 32, 32)),
            label: 'Accueil',
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.search, color: Color.fromARGB(255, 32, 32, 32)),
              label: 'Parcourir'),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, color: Color.fromARGB(255, 32, 32, 32)),
            label: 'Mon compte',
          ),
        ],
      ),
    );
  }
}
