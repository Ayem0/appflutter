import 'package:flutter/material.dart';
import 'package:app_android/screens/localisationChoisirPage_screen.dart';
import 'package:app_android/screens/localisationActuellePage_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class LocalisationPageScreen extends StatefulWidget {
  const LocalisationPageScreen({Key? key, required User user})
      : _user = user,
        super(key: key);
  final User _user;
  @override
  State<LocalisationPageScreen> createState() => _LocalisationPageScreenState();
}

class _LocalisationPageScreenState extends State<LocalisationPageScreen> {
  late User _user;
  String _address = '';
  String _city = "";
  Position? _currentPosition;

  @override
  void initState() {
    _user = widget._user;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back,
              color: Colors.black), // Couleur de la flèche
          onPressed: () {
            // Action à effectuer lors du clic sur la flèche de retour
            Navigator.pop(context);
          },
        ),
        // Vous pouvez également personnaliser l'appBar selon vos besoins
        backgroundColor: Colors.white, // Couleur de fond de l'appBar
        elevation: 0, // Pour supprimer l'ombre de l'appBar
      ),
      backgroundColor: Colors.white, // Couleur de fond de la page entière
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Texte au milieu de la page avec un padding en bas
          const Padding(
            padding: EdgeInsets.only(bottom: 25.0),
            child: Center(
              child: Text(
                'Veuillez renseigner une localisation',
                style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black), // Couleur du texte
              ),
            ),
          ),

          // Bouton "Utiliser ma localisation actuelle"
          ElevatedButton(
            onPressed: () async {
              try {
                Position position = await _determinePosition();
                // Mettez à jour _currentPosition
                setState(() {
                  _currentPosition = position;
                });

                print(
                    'Latitude: ${position.latitude}, Longitude: ${position.longitude}');
                try {
                  // Appelez _getAddressFromCoordinates avec la nouvelle position
                  await _getAddressFromCoordinates();
                  await _getCityFromCoordinates();
                  print('$_city');
                  print('$_address');
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => LocalisationActuelleScreen(
                            user: _user, address: _address, latitude: _currentPosition!.latitude, longitude: _currentPosition!.longitude, city: _city)),
                  );
                } catch (e) {
                  print("Erreur lors de la récupération de l'adresse : $e");
                }
              } catch (e) {
                print('Erreur lors de la récupération de la localisation : $e');
              }
            },
            child: const Text('Utiliser ma localisation actuelle'),
          ),

          // Bouton "Choisir un lieu"
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        LocalisationChoisirScreen(user: _user)),
              );
            },
            child: const Text('Choisir un lieu'),
          ),
        ],
      ),
    );
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  Future<void> _getAddressFromCoordinates() async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        _currentPosition!.latitude,
        _currentPosition!.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark placemark = placemarks[0];
        setState(() {
          _address =
              '${placemark.street}, ${placemark.locality}, ${placemark.country}';
        });
      } else {
        setState(() {
          _address = 'Adresse introuvable';
        });
      }
    } catch (e) {
      print('Erreur lors de la récupération de l\'adresse : $e');
    }
  }
    Future<void> _getCityFromCoordinates() async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        _currentPosition!.latitude,
        _currentPosition!.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark placemark = placemarks[0];
        setState(() {
          _city =
              '${placemark.locality}';
        });
      } else {
        setState(() {
          _city = 'Adresse introuvable';
        });
      }
    } catch (e) {
      print('Erreur lors de la récupération de l\'adresse : $e');
    }
  }
}
