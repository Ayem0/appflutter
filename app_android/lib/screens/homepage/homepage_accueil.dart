import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:app_android/screens/localisationpage_screen.dart';
import '../offerdetail_screen.dart';

class homepageAccueil extends StatefulWidget {
  const homepageAccueil({
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
  State<homepageAccueil> createState() => _homepageAccueilState();
}

class _homepageAccueilState extends State<homepageAccueil> {
  bool isFavorite = false;
  late User _user;
  String _address = ''; // Ajoutez les autres champs nécessaires
  double _latitude = 0.0;
  double _longitude = 0.0;
  String _city = '';
  String _country = '';

  var allItems = List.generate(50, (index) => 'item $index');
  var items = [];
  var searHistory = [];
  final TextEditingController searchController = TextEditingController();
  final SearchController controller = SearchController();
  List<Map<String, dynamic>> newOffers = [];
  List<Map<String, dynamic>> popularOffers = [];
  List<Map<String, dynamic>> closestOffers = [];

  @override
  void initState() {
    _user = widget._user;
    _address = widget._address;
    _latitude = widget._latitude;
    _longitude = widget._longitude;
    _city = widget._city;
    _country = widget._country;
    print(_city +
        _country +
        _address +
        _latitude.toString() +
        _longitude.toString());

    getNewOffers();
    super.initState();
  }

  void search(String query) {
    if (query.isEmpty) {
      setState(() {
        items = allItems;
      });
    } else {
      setState(() {
        items = allItems
            .where((e) => e.toLowerCase().contains(query.toLowerCase()))
            .toList();
      });
    }
  }

  void _closeKeyboard() {
    FocusScope.of(context).requestFocus(FocusNode());
  }

  Future<void> getNewOffers() async {
    try {
      // Récupérer les offres du vendeur depuis Firestore
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection('offres')
              .where('etat', isEqualTo: "disponible")
              .orderBy('date_creation', descending: true)
              .get();

      setState(() {
        newOffers = querySnapshot.docs.map((doc) => doc.data()).toList();
      });
    } catch (e) {
      print('Erreur lors de la récupération des offres : $e');
    }
  }

  // FAIRE LES FONCTIONS POUR AVOIR LES OFFRES POPULAIRES, LES OFFRES LES PLUS PROCHES, LES OFFRES FAVORITES
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: <Widget>[
          // Padding au-dessus du bouton "À Location"
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => LocalisationPageScreen(
                              user: _user,
                            )),
                  );
                },
                child: Text(
                  "À : $_address, $_city",
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color.fromARGB(160, 0, 0, 0), // Couleur du texte
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
            child: Row(
              children: [
                Expanded(
                  child: SearchAnchor(
                    searchController: controller,
                    viewHintText: 'Rechercher...',
                    viewTrailing: [
                      IconButton(
                        onPressed: () {
                          controller.clear();
                        },
                        icon: Icon(Icons.close),
                      ),
                      IconButton(
                        onPressed: () {
                          searHistory.add(controller.text);
                          searHistory = searHistory.reversed.toSet().toList();
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
                              onPressed: () {},
                              icon: Icon(Icons.search),
                            ),
                          ]);
                    },
                    suggestionsBuilder: (context, controller) {
                      return [
                        Wrap(
                          children: List.generate(searHistory.length, (index) {
                            final item = searHistory[index];
                            return Padding(
                              padding: EdgeInsets.only(left: 4, right: 4),
                              child: ChoiceChip(
                                label: Text(item),
                                selected: item == controller.text,
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(24))),
                                onSelected: (value) {
                                  search(item);
                                  controller.closeView(item);
                                },
                              ),
                            );
                          }),
                        ),
                      ];
                    },
                  ),
                ),
              ],
            ),
          ),

          // Le reste du contenu dans une SingleChildScrollView
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  buildCategory("Nouveautés"),
                  buildOfferList(newOffers),

                  // buildCategory("Les plus proches de vous"),
                  // buildOfferList(newOffers),

                  // buildCategory("Nouveautés"),
                  // buildOfferList(newOffers),

                  // buildCategory("Populaires"),
                  // buildOfferList(newOffers),

                  // Répétez le même modèle pour d'autres catégories...
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCategory(String categoryName) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            categoryName,
            style: TextStyle(color: Colors.black),
          ),
          ElevatedButton(
            onPressed: () {
              // Handle "Tout Voir" button click
              // Add your logic here
            },
            style: ButtonStyle(
              padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                EdgeInsets.symmetric(horizontal: 6.0, vertical: 4.0),
              ),
              minimumSize: MaterialStateProperty.all<Size>(Size(0, 0)),
            ),
            child: const Text(
              "Tout voir",
              style: TextStyle(fontSize: 11, color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildOfferList(list) {
    return Align(
      alignment: Alignment.topLeft,
      child: Container(
        width: MediaQuery.of(context).size.width * 2,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(list.length, (index) {
              Map<String, dynamic> offer = list[index];

              return Padding(
                padding: const EdgeInsets.fromLTRB(4, 0, 0, 4),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OffreDetailPage(
                          offer: offer,
                          user: _user,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    height: 150,
                    width: 210,
                    child: Card(
                      elevation: 3,
                      color: Colors.white,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Hero(
                            tag: '${offer['image_url']}',
                            child: Container(
                              height: 70,
                              width: 210,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10.0),
                                  topRight: Radius.circular(10.0),
                                ),
                                image: DecorationImage(
                                  image: NetworkImage(offer['image_url']),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              child: Align(
                                alignment: Alignment.topRight,
                                child: IconButton(
                                  icon: Icon(
                                    isFavorite
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      isFavorite = !isFavorite;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(8, 3, 1, 1),
                            child: Text(
                              offer['nom_du_commerce'] ?? '',
                              style: TextStyle(
                                fontSize: 15,
                              fontWeight: FontWeight.w600,
                                color: Color.fromARGB(255, 50, 50, 50),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(8, 1, 1, 1),
                            child: Text(
                              offer['nom_offre'] ?? '',
                              style: TextStyle(
                                fontSize: 14,
                              fontWeight: FontWeight.w600,
                                color: Color.fromARGB(255, 70, 70, 70),
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(8, 1, 1, 1),
                                child: Text(
                                  "${offer['heure_recup_debut']}-${offer['heure_recup_fin']}",
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(8, 1, 1, 1),
                                child: Text(
                                  "7 kms", // Remplacez par le champ approprié
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              Spacer(),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
                                child: Text(
                                  "${offer['prix']} €",
                                  style: TextStyle(
                                    fontSize: 14,
                              fontWeight: FontWeight.w600,
                                    color: Color.fromARGB(255, 50, 50, 50),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
