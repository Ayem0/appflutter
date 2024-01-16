import 'package:flutter/material.dart';
import 'package:app_android/screens/localisationpage_screen.dart';

class homepageParcourir extends StatefulWidget {
  const homepageParcourir({Key? key}) : super(key: key);

  @override
  State<homepageParcourir> createState() => _homepageParcourirState();
}

class _homepageParcourirState extends State<homepageParcourir> {
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
                  hintStyle: TextStyle(color: Colors.black38), // Couleur du texte d'indice
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black), // Couleur de la bordure de la barre de recherche
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
                              topLeft: Radius.circular(
                                  10.0), // Arrondir le coin haut gauche
                              topRight: Radius.circular(
                                  10.0), // Arrondir le coin haut droit
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
            }),
          ),
        ),
      ),
    );
  }
}
