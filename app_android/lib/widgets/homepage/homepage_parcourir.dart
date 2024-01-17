import 'package:flutter/material.dart';
import 'package:app_android/screens/localisationpage_screen.dart';

class homepageParcourir extends StatefulWidget {
  const homepageParcourir({super.key});

  @override
  State<homepageParcourir> createState() => _homepageParcourirState();
}

class _homepageParcourirState extends State<homepageParcourir> {
  // Variable pour stocker la valeur du texte
  int numberOfItems = 30;
  int numberZero = 0;
  var allItems = List.generate(50, (index) => 'item $index');
  var items = [];
  var searHistory = [];
  final TextEditingController searchController = TextEditingController();
  final SearchController controller = SearchController();

  @override
  void initState() {
    super.initState();
    searchController.addListener(queryListener);
  }

  void queryListener() {
    search(searchController.text);
  }

  @override
  void dispose() {
    searchController.removeListener(queryListener);
    searchController.dispose();
    super.dispose();
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
                  MaterialPageRoute(builder: (context) => LocalisationPage()),
                );
              },
              child: const Text(
                "À Location",
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
        height: 160,
        child: Card(
          elevation: 3, 
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 80,
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
                    padding: EdgeInsets.fromLTRB(8, 0, 0, 0),
                    child: Text(
                      "08:00-18:00",
                      style: TextStyle(
                        color: Colors.black, // Couleur du texte
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(8, 0, 0, 0),
                    child: Text(
                      "7 kms",
                      style: TextStyle(
                        color: Colors.black, // Couleur du texte
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(170, 0, 0, 0),
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
