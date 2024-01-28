import 'package:app_android/screens/homepage_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geocoding/geocoding.dart';
import 'package:latlong2/latlong.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LocalisationActuelleScreen extends StatefulWidget {
   LocalisationActuelleScreen({
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
  State<LocalisationActuelleScreen> createState() =>
      _LocalisationActuelleScreenState();
}

class _LocalisationActuelleScreenState
    extends State<LocalisationActuelleScreen> {
  final TextEditingController searchController = TextEditingController();
  final SearchController controller = SearchController();

  LatLng? _selectedLocation;
  String city = "";
  String address = "";
  double latitude = 0;
  double longitude = 0;
  String country = "";
  String adresse = "";
  List<Location> locations = [];

  @override
  void initState() {
    super.initState();
    _selectedLocation = LatLng(widget._latitude, widget._longitude);
    address = widget._address;
    city = widget._city;
    latitude = widget._latitude;
    longitude = widget._longitude;
    country = widget._country;
  }

  void _closeKeyboard() {
    FocusScope.of(context).requestFocus(FocusNode());
  }

  void _getDetailsFromCoordinates(double a, double b) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(a, b);

      if (placemarks.isNotEmpty) {
        Placemark placemark = placemarks[0];
        setState(() {
          address = '${placemark.street}';
          city = '${placemark.locality}';
          longitude = a;
          latitude = b;
          country = '${placemark.country}';
        });
      } else {
        setState(() {
          address = 'Adresse introuvable';
          city = 'Ville introuvable';
        });
      }
    } catch (e) {
      print('Erreur lors de la récupération des détails : $e');
    }
  }

  Future<void> addLocalisationToUser(String userId, String adresse, String city,
      double longitude, double latitude, String country) async {
    // Ajoutez un document dans la collection 'utilisateurs' avec le champ 'isSeller'
    await FirebaseFirestore.instance
        .collection('utilisateurs')
        .doc(userId)
        .update({
      'adresse': widget._address,
      'ville': city,
      'longitude': longitude,
      'latitude': latitude,
      'pays': widget._country,
      // Ajoutez d'autres champs si nécessaire
    });
  }

  void _handleSearch() async {
    if (controller.text.isNotEmpty) {
      try {
        locations = await locationFromAddress(controller.text);

        if (locations.isNotEmpty) {
          setState(() {
            _selectedLocation = LatLng(
              locations[0].latitude,
              locations[0].longitude,
            );
          });
          _getDetailsFromCoordinates(
            locations[0].latitude,
            locations[0].longitude,
          );

          // Appeler la fonction pour obtenir les détails
        }
      } catch (e) {
        print('Erreur lors de la récupération des détails : $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Container(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.black),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ),
            // SearchAnchor
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8, bottom: 8),
              child: SearchAnchor(
                searchController: controller,
                viewHintText: '',
                viewTrailing: [
                  IconButton(
                    onPressed: () {
                      controller.clear();
                    },
                    icon: const Icon(Icons.close),
                  ),
                  IconButton(
                    onPressed: () {
                      _handleSearch();
                      controller.closeView(controller.text);
                      _closeKeyboard();
                    },
                    icon: const Icon(Icons.search),
                  ),
                ],
                builder: (context, controller) {
                  return SearchBar(
                    controller: controller,
                    hintText: 'Rechercher...',
                    onTap: () => controller.openView(),
                    trailing: [
                      IconButton(
                        onPressed: () {
                          _handleSearch();
                        },
                        icon: const Icon(Icons.search),
                      ),
                    ],
                  );
                },
                suggestionsBuilder: (context, controller) {
                  return [
                    const Wrap(),
                  ];
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: 440,
                width: 320,
                child: FlutterMap(
                  key: Key(_selectedLocation?.toString() ?? ""),
                  options: MapOptions(
                    initialCenter: _selectedLocation ?? LatLng(0, 0),
                    initialZoom: 16,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.example.app',
                    ),
                    MarkerLayer(
                      markers: _selectedLocation != null
                          ? [
                              Marker(
                                point: _selectedLocation!,
                                width: 30,
                                height: 30,
                                child: const Icon(Icons.place),
                              ),
                            ]
                          : [],
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 16.0, left: 16, bottom: 8),
              child: Text("Adresse trouvée : $address, $city, $country"),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        child: ElevatedButton(
          onPressed: () {
            if (address != 'Adresse introuvable' && address != "") {
              addLocalisationToUser(widget._user.uid, address, city, longitude,
                  latitude, country);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HomepageScreen(
                    user: widget._user,
                    address: address,
                    longitude: longitude,
                    latitude: latitude,
                    city: city,
                    country: country,
                  ),
                ),
              );
            }
          },
          child: const Text("Valider l'adresse"),
        ),
      ),
    );
  }
}
