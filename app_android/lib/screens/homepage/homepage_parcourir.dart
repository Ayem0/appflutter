import 'package:app_android/screens/offerdetail_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:app_android/screens/localisationpage_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

String prixMoins = "Prix (moins chère)";
String prixPlus = "Prix (plus chère)";

enum FilterOption { Distance, prixMoins, prixPlus, Note }

FilterOption _selectedFilter = FilterOption.Distance;

class HomepageParcourir extends StatefulWidget {
  const HomepageParcourir({
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
  State<HomepageParcourir> createState() => _HomepageParcourirState();
}

class _HomepageParcourirState extends State<HomepageParcourir> {
  bool isFavorite = false;
  // Variable pour stocker la valeur du texte
  int numberOfItems = 30;
  int numberZero = 0;
  var allItems = List.generate(50, (index) => 'item $index');
  var items = [];
  var searHistory = [];
  final TextEditingController searchController = TextEditingController();
  final SearchController controller = SearchController();

  late User _user;
  String textFiltre = "Distance";
  String _address = ''; // Ajoutez les autres champs nécessaires
  double _latitude = 0.0;
  double _longitude = 0.0;
  String _city = '';
  String _country = '';
  List<Map<String, dynamic>> offers = [];

  @override
  void initState() {
    _user = widget._user;
    _address = widget._address;
    _latitude = widget._latitude;
    _longitude = widget._longitude;
    _city = widget._city;
    _country = widget._country;
    searchController.addListener(queryListener);
    getOffersOrderByPriceDesc();
    super.initState();
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

  Future<void> getOffersOrderByPriceDesc() async {
    try {
      // Récupérer les offres du vendeur depuis Firestore
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection('offres')
              .where('etat', isEqualTo: "disponible")
              .orderBy('prix', descending: true)
              .get();

      setState(() {
        offers = querySnapshot.docs.map((doc) => doc.data()).toList();
      });
    } catch (e) {
      print('Erreur lors de la récupération des offres : $e');
    }
  }

  Future<void> getOffersOrderByPriceAsc() async {
    try {
      // Récupérer les offres du vendeur depuis Firestore
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection('offres')
              .where('etat', isEqualTo: "disponible")
              .orderBy('prix', descending: false)
              .get();

      setState(() {
        offers = querySnapshot.docs.map((doc) => doc.data()).toList();
      });
    } catch (e) {
      print('Erreur lors de la récupération des offres : $e');
    }
  }

  String getFilterOptionText(FilterOption option) {
    switch (option) {
      case FilterOption.Distance:
        return 'Distance';
      case FilterOption.prixMoins:
        return 'Prix (moins chère)';
      case FilterOption.prixPlus:
        return 'Prix (plus chère)';
      case FilterOption.Note:
        return 'Note';
    }
  }

  void _openBottomSheet(BuildContext context) {
    showModalBottomSheet(
      constraints: const BoxConstraints(minHeight: 300, minWidth: 400),
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Center(
                    child: Text(
                      'Trier par :',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  ListTile(
                    title: const Text('Distance'),
                    leading: Radio<FilterOption>(
                      value: FilterOption.Distance,
                      groupValue: _selectedFilter,
                      onChanged: (FilterOption? value) {
                        setState(() {
                          textFiltre = getFilterOptionText(_selectedFilter);
                          _selectedFilter = value ?? FilterOption.Distance;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  ListTile(
                    title: const Text('Prix (moins chère)'),
                    leading: Radio<FilterOption>(
                      value: FilterOption.prixMoins,
                      groupValue: _selectedFilter,
                      onChanged: (FilterOption? value) {
                        setState(() {
                          textFiltre = getFilterOptionText(_selectedFilter);
                          _selectedFilter = value ?? FilterOption.Distance;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  ListTile(
                    title: const Text('Prix (plus chère)'),
                    leading: Radio<FilterOption>(
                      value: FilterOption.prixPlus,
                      groupValue: _selectedFilter,
                      onChanged: (FilterOption? value) {
                        setState(() {
                          textFiltre = getFilterOptionText(_selectedFilter);
                          _selectedFilter = value ?? FilterOption.Distance;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  ListTile(
                    title: const Text('Note'),
                    leading: Radio<FilterOption>(
                      value: FilterOption.Note,
                      groupValue: _selectedFilter,
                      onChanged: (FilterOption? value) {
                        setState(() {
                          textFiltre = getFilterOptionText(_selectedFilter);
                          _selectedFilter = value ?? FilterOption.Distance;
                        });
                      },
                    ),
                  ),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        textFiltre = getFilterOptionText(_selectedFilter);
                        Navigator.of(context).pop();
                        setState(() {
                  
                          // reload the page
                        }); 
                      },
                      child: const Text('Valider'),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
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
                      icon: const Icon(Icons.close),
                    ),
                    IconButton(
                      onPressed: () {
                        searHistory.add(controller.text);
                        searHistory = searHistory.reversed.toSet().toList();
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
                            onPressed: () {},
                            icon: const Icon(Icons.search),
                          ),
                        ]);
                  },
                  suggestionsBuilder: (context, controller) {
                    return [
                      Wrap(
                        children: List.generate(searHistory.length, (index) {
                          final item = searHistory[index];
                          return Padding(
                            padding: const EdgeInsets.only(left: 4, right: 4),
                            child: ChoiceChip(
                              label: Text(item),
                              selected: item == controller.text,
                              shape: const RoundedRectangleBorder(
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
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
          child: Column(
            children: [
              Row(
                children: [
                  const Text('Trier par : '),
                  TextButton(
                    onPressed: () {
                      _openBottomSheet(context);
                    },
                    child: Text(textFiltre,
                        style: const TextStyle(color: Colors.blueGrey)),
                  ),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            child: buildOfferList(offers),
          ),
        ),
      ]),
    );
  }

  Widget buildOfferList(list) {
    return Align(
      alignment: Alignment.topLeft,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: List.generate(list.length, (index) {
            Map<String, dynamic> offer = list[index];

            return Padding(
              padding: const EdgeInsets.all(4.0),
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
                child: SizedBox(
                  height: 160,
                  child: Card(
                    elevation: 3,
                    color: Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Hero(
                          tag: '${offer['image_url']}',
                          child: Container(
                            height: 75,
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.only(
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
                          padding: const EdgeInsets.fromLTRB(10, 4, 0, 4),
                          child: Text(
                            offer['nom_du_commerce'] ?? '',
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Color.fromARGB(255, 49, 49, 49), // Couleur du texte
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10, 0, 0, 2),
                          child: Text(
                            offer['nom_offre'] ?? '',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color.fromARGB(255, 74, 74, 74), // Couleur du texte
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(10, 2, 0, 2),
                              child: Text(
                                "${offer['heure_recup_debut']}-${offer['heure_recup_fin']}",
                                style: const TextStyle(
                                  color: Colors.black, // Couleur du texte
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                              child: Text(
                                "7 kms",
                                style: const TextStyle(
                                  color: Colors.black, // Couleur du texte
                                ),
                              ),
                            ),
                            Spacer(),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                              child: Text(
                                "${offer['prix']} €",
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Color.fromARGB(255, 70, 70, 70), // Couleur du texte
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
    );
  }
}
