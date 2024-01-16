import 'package:flutter/material.dart';
import 'package:app_android/screens/localisationpage_screen.dart';

class HomepagePanier extends StatefulWidget {
  const HomepagePanier({super.key});

  @override
  State<HomepagePanier> createState() => _homepagePanierState();
}

class _homepagePanierState extends State<HomepagePanier> {
  // Variable pour stocker la valeur du texte
  int numberOfItems = 30;
  int numberZero = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(children: <Widget>[
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
                            builder: (context) => LocalisationPage()),
                      );
                },
              child: const Text(
                "À Location",
                style: TextStyle(
                  color: Colors.black54, // Couleur du texte
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
                        color: Colors.black), // Couleur du texte d'indice
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors
                              .black), // Couleur de la bordure de la barre de recherche
                    ),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(
                  Icons.search,
                  color: Colors.black,
                ),
                onPressed: () {
                  // Logique de recherche
                },
              ),
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: List.generate(
                numberOfItems,
                (index) => buildOfferCard(),
              ),
            ),
          ),
        ),
      ]),
    );
  }

  Widget buildOfferCard() {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Container(
        height: 130,
        child: Card(
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 50,
                width: 150,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft:
                        Radius.circular(10.0), // Arrondir le coin haut gauche
                    topRight:
                        Radius.circular(10.0), // Arrondir le coin haut droit
                  ),
                  image: DecorationImage(
                    image: AssetImage(
                        'assets/launchingpage_image/interieur-boulangerie.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(8, 1, 1, 1),
                child: Text(
                  "Nom du commerce",
                  style: TextStyle(
                    color: Colors.black, // Couleur du texte
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(8, 1, 1, 1),
                child: Text(
                  "Heure",
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
                      "Distance",
                      style: TextStyle(
                        color: Colors.black, // Couleur du texte
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(50, 0, 0, 0),
                    child: Text(
                      "Prix",
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
  }
}
