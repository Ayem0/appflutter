import 'package:app_android/screens/createOffer_screen.dart';
import 'package:app_android/screens/homepage_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

String nomDuCommerce =
    "Boulangerie de la mairie"; // a remplacer par nom du commerce

class SellerHomepageScreen extends StatefulWidget {
  const SellerHomepageScreen({
    super.key,
    required User user,
  }) : _user = user;

  final User _user;

  @override
  State<SellerHomepageScreen> createState() => _SellerHomepageScreenState();
}

class _SellerHomepageScreenState extends State<SellerHomepageScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: <Widget>[
          // Padding au-dessus du bouton "À Location"
          Padding(
            padding: const EdgeInsets.only(top: 24.0, left: 8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => HomepageScreen(
                              user: widget._user,
                              address: "",
                              city: "",
                              latitude: 0,
                              longitude: 0,
                              country: "",
                            )),
                  );
                },
                child: Text(
                  "Revenir à l'interface utilisateur",
                  style: TextStyle(
                    color: Color.fromARGB(160, 0, 0, 0), // Couleur du texte
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 28, bottom: 20),
            child: Text(
              nomDuCommerce,
              style: const TextStyle(fontSize: 20),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CreateOfferScreen(
                              user: widget._user,
                            )),
                  );
                },
                child: Text(
                  "Ajouter une offre",
                  style: TextStyle(
                    color: Color.fromARGB(160, 0, 0, 0), // Couleur du texte
                  ),
                ),
              ),
            ),
          ),

          // Le reste du contenu dans une SingleChildScrollView
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  buildCategory("Offres actuelles"),
                  buildOfferList(),
                  buildCategory("Offres vendues"),
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
                padding: const EdgeInsets.fromLTRB(4, 0, 0, 4),
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
                                Icons.delete,
                                color: Colors.white, // Couleur du cœur
                              ),
                              onPressed: () {
                                //
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
