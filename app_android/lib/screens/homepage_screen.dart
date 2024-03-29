import 'package:app_android/screens/localisationGoogle_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'homepage/homepage_mon_compte.dart';
import 'homepage/homepage_parcourir.dart';
import 'homepage/homepage_accueil.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class HomepageScreen extends StatefulWidget {
  const HomepageScreen({
    super.key,
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
        _country = country;

  final User _user;
  final String _address;
  final double _latitude;
  final double _longitude;
  final String _city;
  final String _country;
  @override
  State<HomepageScreen> createState() => _HomepageScreenState();
}

class _HomepageScreenState extends State<HomepageScreen> {
  int _currentIndex = 0;
  late User _user;
  String _address = ''; // Ajoutez les autres champs nécessaires
  double _latitude = 0.0;
  double _longitude = 0.0;
  String _city = '';
  String _country = '';

  @override

   void initState() {
    _user = widget._user;
    _loadUserLocation(widget._user.uid);
    super.initState();
  }

  void _loadUserLocation(user) async {
    Map<String, dynamic> userData =
        await getLocalisationFromUser(user);

    setState(() {
      // Mettez à jour les données du widget avec celles récupérées de la base de données
      _address = userData['adresse'] ?? '';
      _latitude = userData['latitude'] ?? 0.0;
      _longitude = userData['longitude'] ?? 0.0;
      _city = userData['ville'] ?? '';
      _country = userData['pays'] ?? '';
      print(_address + _latitude.toString() + _longitude.toString() + _city + _country);
    });
  }

 Future<Map<String, dynamic>> getLocalisationFromUser(String userId) async {
    try {
      // Récupère le document utilisateur
      DocumentSnapshot userDocument =
          await FirebaseFirestore.instance.collection('utilisateurs').doc(userId).get();

      // Vérifie si le document existe
      if (userDocument.exists) {
        Map<String, dynamic> userData = userDocument.data() as Map<String, dynamic>;
        if (userData['adresse'] != null) {
                  return userDocument.data() as Map<String, dynamic>;
        }
        else {
          Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LocalisationGooglePageScreen(user: widget._user,)),
                      );
        return {};
        }
        // Renvoie les données du document sous forme de Map
      } else {

        Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LocalisationGooglePageScreen(user: widget._user,)),
                      );
        return {};
      }
    } catch (e) {
      print('Erreur lors de la récupération des informations utilisateur : $e');
      return {};
    }
  }
  
  @override

  

  Widget build(BuildContext context) {
    // Vérifie si les données de localisation ont été chargées avec succès
  bool dataLoaded = _city.isNotEmpty && _address.isNotEmpty && _latitude != 0.0 && _longitude != 0.0;

  Widget content;

  // Si les données sont chargées, construisez le contenu de la page
  if (dataLoaded) {
    switch (_currentIndex) {
      case 0:
        content = homepageAccueil(user: _user, longitude: _longitude, latitude: _latitude, city: _city, address: _address, country: _country,);
        break;
      case 1:
        content = HomepageParcourir(user: _user,longitude: _longitude, latitude: _latitude, city: _city, address: _address, country: _country,);
        break;
      case 2:
        content = homepageMoncompte(user: _user,longitude: _longitude, latitude: _latitude, city: _city, address: _address, country: _country,);
        break;
      default:
        content = homepageAccueil(user: _user,longitude: widget._longitude, latitude: widget._latitude, city: widget._city, address: widget._address, country: widget._country,);
    }
  } else {
    // Si les données ne sont pas encore chargées, affichez un indicateur de chargement ou ne rien afficher
    content = const Center(
      child: CircularProgressIndicator(strokeAlign:  1),
    );// Remplacez ceci par l'indicateur de chargement souhaité
  }

    return Scaffold(
      body: content,
      bottomNavigationBar: BottomNavigationBar(
        unselectedLabelStyle: const TextStyle(
            color: Color.fromARGB(255, 32, 32, 32), fontSize: 14),
        selectedLabelStyle: const TextStyle(
            color: Color.fromARGB(255, 32, 32, 32), fontSize: 14),
        selectedItemColor: const Color.fromARGB(255, 32, 32, 32),
        backgroundColor: Colors.white,
        unselectedItemColor: const Color.fromARGB(255, 32, 32, 32),
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
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


