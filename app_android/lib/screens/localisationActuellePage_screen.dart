import 'package:app_android/screens/homepage_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_map/flutter_map.dart';

class LoacalisationActuelleScreen extends StatefulWidget {
  const LoacalisationActuelleScreen({
    Key? key,
    required User user,
    required String address,
  })  : _user = user,
        _address = address,
        super(key: key);

  final User _user;
  final String _address;
  @override
  State<LoacalisationActuelleScreen> createState() =>
      _LocalisationActuelleScreenState();
}

class _LocalisationActuelleScreenState
    extends State<LoacalisationActuelleScreen> {
  final TextEditingController searchController = TextEditingController();
  final SearchController controller = SearchController();

  void _closeKeyboard() {
    FocusScope.of(context).requestFocus(FocusNode());
  }

  @override
  Widget build(BuildContext context) {
    controller.text = widget._address;
    return Scaffold(
      body: ListView(
        children: [
          // Flèche de retour
          Container(
            alignment: Alignment.centerLeft,
            child: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () {
                Navigator.pop(context);
              },
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
                  onPressed: () {
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
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => HomepageScreen(user: widget._user)),
              );
          },
          child: Text("Valider l'adresse"),
        ),
      ),
    );
  }
}
