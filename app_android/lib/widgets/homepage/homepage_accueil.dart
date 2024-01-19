import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:app_android/screens/localisationpage_screen.dart';

class homepageAccueil extends StatefulWidget {
  const homepageAccueil({
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
  State<homepageAccueil> createState() => _homepageAccueilState();
}

class _homepageAccueilState extends State<homepageAccueil> {
  bool isFavorite = false;
  late User _user;

  @override
  void initState() {
    _user = widget._user;
    super.initState();
  }

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
                child:  Text(
                  "À ${widget._city}",
                  style: TextStyle(
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
                  child: TextFormField(
                    decoration: const InputDecoration(
                      hintText: 'Recherche...',
                      hintStyle: TextStyle(
                          color: Colors.black38), // Couleur du texte d'indice
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors
                                .black), // Couleur de la bordure de la barre de recherche
                      ),
                      fillColor: Colors.black,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.search,
                    color: Colors.black38,
                  ),
                  onPressed: () {
                    // Logique de recherche
                  },
                ),
              ],
            ),
          ),

          // Le reste du contenu dans une SingleChildScrollView
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  buildCategory("Favoris"),
                  buildOfferList(),

                  buildCategory("Recommandés pour vous"),
                  buildOfferList(),

                  buildCategory("Les plus proches de vous"),
                  buildOfferList(),

                  buildCategory("Nouveautés"),
                  buildOfferList(),

                  buildCategory("Populaires"),
                  buildOfferList(),

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
      padding: const EdgeInsets.all(8.0),
      child: Container(
        alignment: Alignment.topLeft,
        child: Text(
          categoryName,
          style: TextStyle(color: Colors.black),
        ),
      ),
    );
  }

  Widget buildOfferList() {
    return Align(
      alignment: Alignment.topLeft,
      child: Container(
        width: MediaQuery.of(context).size.width * 2,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(20, (index) {
              return Padding(
                padding: const EdgeInsets.fromLTRB(4,4,0,4),
                child: Container(
                  height: 150,
                  width: 210,
                  child: Card(
                    elevation: 3,
                    color: Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 70,
                          width: 210,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10.0),
                              topRight: Radius.circular(10.0),
                            ),
                            image: DecorationImage(
                              image: AssetImage(
                                  'assets/launchingpage_image/interieur-boulangerie.jpg'),
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
                                color: Colors.white, // Couleur du cœur
                              ),
                              onPressed: () {
                                setState(() {
                                  isFavorite = !isFavorite;
                                });
                              },
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.fromLTRB(8, 3, 1, 1),
                          child: Text(
                            "Boulangerie de la mairie",
                            style: TextStyle(
                              color: Colors.black, // Couleur du texte
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.fromLTRB(8, 1, 1, 1),
                          child: Text(
                            "Pain au chocolat",
                            style: TextStyle(
                              color: Colors.black, // Couleur du texte
                            ),
                          ),
                        ),
                        const Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.fromLTRB(8, 1, 1, 1),
                              child: Text(
                                "08:00-18:00",
                                style: TextStyle(
                                  color: Colors.black, // Couleur du texte
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(8, 1, 1, 1),
                              child: Text(
                                "7 kms",
                                style: TextStyle(
                                  color: Colors.black, // Couleur du texte
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(16, 0, 8, 0),
                              child: Text(
                                "3.00 €",
                                style: TextStyle(
                                  color: Colors.black, // Couleur du texte
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
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
