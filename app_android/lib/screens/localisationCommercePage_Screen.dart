import 'package:app_android/screens/homepage_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geocoding/geocoding.dart';
import 'package:latlong2/latlong.dart';

class LocalisationCommerceScreen extends StatefulWidget {
  const LocalisationCommerceScreen({
    Key? key,
    required User user,
  })  : _user = user,
        super(key: key);

  final User _user;

  @override
  State<LocalisationCommerceScreen> createState() =>
      _LocalisationCommerceScreenState();
}

class _LocalisationCommerceScreenState
    extends State<LocalisationCommerceScreen> {
  final TextEditingController searchController = TextEditingController();
  final SearchController controller = SearchController();
  LatLng? _selectedLocation;
  String address = '';
  String city = "";
  String country = "";
  List<Location> locations = [];
  bool _searched = false;

  void _closeKeyboard() {
    FocusScope.of(context).requestFocus(FocusNode());
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
          _searched = true;

          // Appeler la fonction pour obtenir les détails
        }
      } catch (e) {
        print('Erreur lors de la récupération des détails : $e');
      }
    }
  }

  Future<void> setLocalisationToSellerDocument(String userId, String adresse,
      String city, double longitude, double latitude, String country) async {
    // Ajoutez un document dans la collection 'utilisateurs' avec le champ 'isSeller'
    await FirebaseFirestore.instance.collection('vendeurs').doc(userId).update({
      'adresse': address,
      'ville': city,
      'longitude': longitude,
      'latitude': latitude,
      'pays': country,
      // Ajoutez d'autres champs si nécessaire
    });
  }

  Future<void> _getDetailsFromCoordinates(
      double latitude, double longitude) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude);

      if (placemarks.isNotEmpty) {
        Placemark placemark = placemarks[0];
        setState(() {
          address = '${placemark.street}';
          city = '${placemark.locality}';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Container(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.black),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ),
            // SearchAnchor
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8),
              child: SearchAnchor(
                searchController: controller,
                viewHintText: '',
                viewTrailing: [
                  IconButton(
                    onPressed: () {
                      controller.clear();
                    },
                    icon: Icon(Icons.close),
                  ),
                  IconButton(
                    onPressed: () async {
                      _handleSearch(); // Appeler la fonction de recherche
                      controller.closeView(controller.text);
                      _closeKeyboard();
                    },
                    icon: Icon(Icons.search),
                  ),
                ],
                builder: (context, controller) {
                  return SearchBar(
                    controller: controller,
                    hintText: 'Rechercher...',
                    onTap: () => controller.openView(),
                    trailing: [
                      IconButton(
                        onPressed: () async {
                          _handleSearch(); // Appeler la fonction de recherche
                        },
                        icon: Icon(Icons.search),
                      ),
                    ],
                  );
                },
                suggestionsBuilder: (context, controller) {
                  return [
                    Wrap(),
                  ];
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 16, 8, 16),
              child: Container(
                height: 420,
                width: 320,
                child: _searched
                    ? FlutterMap(
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
                                      child: Icon(Icons.place),
                                    ),
                                  ]
                                : [],
                          ),
                        ],
                      )
                    : Container(),
              ),
            ),
            _searched
                ? Padding(
                    padding:
                        const EdgeInsets.only(right: 16.0, left: 16, bottom: 8),
                    child: Container(
                      child: Text(
                          "Adresse trouvée : ${address}, ${city}, ${country}"),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.fromLTRB(8.0, 0, 8, 0),
                    child: Center(
                      child: Text(
                          style: TextStyle(fontSize: 20),
                          'Veuillez saisir une localisation pour votre commerce.'),
                    ),
                  ),
          ],
        ),
      ),

      // Flèche de retour
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        child: ElevatedButton(
          onPressed: () {
            if (address != 'Adresse introuvable' && address != "") {
              setLocalisationToSellerDocument(
                  widget._user.uid,
                  address,
                  city,
                  locations.isNotEmpty ? locations[0].longitude : 0,
                  locations.isNotEmpty ? locations[0].latitude : 0,
                  country);

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HomepageScreen(
                    user: widget._user,
                    address: address,
                    longitude: locations.isNotEmpty ? locations[0].latitude : 0,
                    latitude: locations.isNotEmpty ? locations[0].longitude : 0,
                    city: city,
                    country: country,
                  ),
                ),
              );
            }
          },
          child: Text("Valider l'adresse"),
        ),
      ),
    );
  }
}
