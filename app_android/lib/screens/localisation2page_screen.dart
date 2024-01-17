import 'package:flutter/material.dart';

class Localisation2PageScreen extends StatefulWidget {
  const Localisation2PageScreen({super.key});

  @override
  State<Localisation2PageScreen> createState() =>
      _Localisation2PageScreenState();
}

class _Localisation2PageScreenState extends State<Localisation2PageScreen> {
  final TextEditingController searchController = TextEditingController();
  final SearchController controller = SearchController();

  void _closeKeyboard() {
    FocusScope.of(context).requestFocus(FocusNode());
  }

  @override
  Widget build(BuildContext context) {
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
            // Action à effectuer lors du clic sur le bouton "Continuer"
          },
          child: Text('Continuer'),
        ),
      ),
    );
  }
}
