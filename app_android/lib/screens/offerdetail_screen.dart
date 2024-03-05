import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class OffreDetailPage extends StatefulWidget {
  const OffreDetailPage({
    Key? key,
    required User user,
    required String address,
    required double latitude,
    required double longitude,
    required String city,
    required String country,
    required Map<String, dynamic> offer,
  })  : _user = user,
        _address = address,
        _latitude = latitude,
        _longitude = longitude,
        _city = city,
        _country = country,
        _offer = offer,
        super(key: key);

  final User _user;
  final String _address;
  final double _latitude;
  final double _longitude;
  final String _city;
  final String _country;
  final Map<String, dynamic> _offer;

  @override
  _OffreDetailPageState createState() => _OffreDetailPageState();
}

class _OffreDetailPageState extends State<OffreDetailPage> {
  bool isFavorited = false;
  late User _user;
  late Map<String, dynamic> _offer;
  late double distance;
  late double distanceEnMetre;
  late String distanceToString;
  String _address = ''; // Ajoutez les autres champs nécessaires
  double _latitude = 0.0;
  double _longitude = 0.0;
  String _city = '';
  String _country = '';

  @override
  void initState() {
    _user = widget._user;
    _offer = widget._offer;
    _address = widget._address;
    _latitude = widget._latitude;
    _longitude = widget._longitude;
    _city = widget._city;
    _country = widget._country;
    calculateDistance();
    super.initState();
  }

  void calculateDistance() async {
    try {
      distance = await Geolocator.distanceBetween(
        _latitude,
        _longitude,
        _offer['latitude'],
        _offer['longitude'],
      );
      distanceEnMetre = (distance / 1000.0);
      if(distanceEnMetre >= 2) distanceToString = (distance / 1000.0).toStringAsFixed(1) + ' kms';
      if(distanceEnMetre < 2) distanceToString = (distance / 1000.0).toStringAsFixed(1) + ' km';
       // Mise à jour de l'affichage après le calcul de la distance
      setState(() {});
    } catch (e) {
      print("Erreur lors du calcul de la distance : $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Image en haut de la page
          SizedBox(
            height: 200.0,
            child: Stack(
              children: [
                Hero(
                  tag: '${_offer['image_url']}',
                  child: Container(
                    height: 70,
                    width: 210,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10.0),
                        topRight: Radius.circular(10.0),
                      ),
                      image: DecorationImage(
                        image: NetworkImage(_offer['image_url']),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                // Flèche de retour
                Positioned(
                  top: 16.0,
                  left: 8.0,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                      // Action à effectuer lors du clic sur la flèche de retour
                      Navigator.pop(context);
                    },
                  ),
                ),
                // Cœur cliquable en haut à droite
                Positioned(
                  top: 16.0,
                  right: 16.0,
                  child: IconButton(
                    icon: Icon(
                      isFavorited ? Icons.favorite : Icons.favorite_border,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      // Action à effectuer lors du clic sur le cœur
                      setState(() {
                        isFavorited = !isFavorited;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // En-tête avec couleur de fond grise
              Container(
                color: Colors.grey,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Text(
                  '${_offer['nom_du_commerce']}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                  ),
                ),
              ),
              // Espacement
              const SizedBox(height: 10.0),
              // Nom, distance, description
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: Text(
                      '${_offer['nom_offre']}',
                      style: const TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black, // Couleur noire
                      ),
                    ),
                  ),
                  // Ajout d'un padding à droite
                  Padding(
                    padding: const EdgeInsets.only(right: 12.0),
                    child: Text(
                      '${_offer['prix']} €',
                      style: const TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black, // Couleur noire
                      ),
                    ),
                  ),
                ],
              ),
              // Espacement
              const SizedBox(height: 8.0),
              // Heure et distance sur la même ligne
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16.0, 0, 0, 0),
                    child: Text(
                      'Récupérer à : ${_offer['heure_recup_debut']}-${_offer['heure_recup_fin']}',
                      style: const TextStyle(
                        fontSize: 13.0,
                        color: Colors.black, // Couleur noire
                      ),
                    ),
                  ),
                  // Ajout d'un padding à droite
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16.0, 5, 16, 0),
                    child: Text(
                      'Distance : $distanceToString',
                      style: const TextStyle(
                        fontSize: 13.0,
                        color: Colors.black, // Couleur noire
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16.0, 0, 0, 2),
                      child: Text(
                        'Adresse : ${_offer['adresse']}',
                        style: const TextStyle(
                          fontSize: 13.0,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16.0, 0, 0, 2),
                    child: IconButton(
                      icon: const Icon(Icons.map),
                      onPressed: () {
                        // Action à effectuer lors du clic sur le bouton "Plus d'informations"
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
          // Contenu de la page dans une SingleChildScrollView
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16.0, 5, 16, 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    '${_offer['description']}',
                    style:
                        const TextStyle(color: Colors.black), // Couleur noire
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur iaculis malesuada ullamcorper. Aliquam erat volutpat. Etiam arcu lacus, malesuada quis mi eu, vulputate lobortis metus. Mauris dolor mi, congue eu quam at, accumsan hendrerit nunc. Nulla id felis accumsan, molestie arcu eu, rutrum mi. Ut nec porttitor tortor, vel tincidunt lorem. Nulla porta elit auctor urna elementum, non pharetra orci cursus. Donec cursus, sem at ultrices vehicula, eros arcu hendrerit est, ut finibus odio dui ac nulla. Donec eleifend enim et condimentum dictum. Integer vehicula accumsan urna, nec imperdiet dui ultricies eget. Integer lobortis arcu metus, sed faucibus mi efficitur ac. Nulla ante quam, laoreet in malesuada in, facilisis vel ipsum. Nullam et urna eget elit posuere tristique ac quis arcu.',
                    style:
                        const TextStyle(color: Colors.black), // Couleur noire
                  ),
                ],
              ),
            ),
          ),
          Container(
            width: double
                .infinity, // Ceci étend le conteneur à la largeur maximale disponible
            padding: const EdgeInsets.fromLTRB(16, 8, 16,
                8), // Ajoutez un padding horizontal pour l'espacement
            child: ElevatedButton(
              onPressed: () {
                // Action à effectuer lors du clic sur le bouton Réserver
              },
              child: const Text(
                'Réserver', // Couleur blanche
              ),
            ),
          )
        ],
      ),
    );
  }
}
