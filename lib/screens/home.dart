import 'package:flutter/material.dart';
import 'package:millions/constants/colors.dart';
import 'package:millions/screens/createPost.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:millions/screens/screen11.dart';
import 'package:millions/screens/screen14.dart';
import 'package:millions/screens/screen5.dart';
import 'package:millions/screens/screen9.dart';
import 'package:millions/screens/verification.dart';
import 'package:millions/screens/shorts.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  void openDrawer() {
    _drawerKey.currentState.openDrawer();
  }

  final _SearchDemoSearchDelegate _delegate = _SearchDemoSearchDelegate();

  int _lastIntegerSelected;

  final pages = [Screen5(), Shorts(), CreatePage(), Screen9(), Screen11()];
  int page = 0;

  @override
  initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        key: _drawerKey,
        drawer: Drawer(
          child: Column(
            children: [
              DrawerHeader(
                child: Container(
                    height: 142,
                    width: MediaQuery.of(context).size.width,
                    child: Image.asset(
                      "images/million logo with millions.png",
                    )),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                ),
              ),
              ListTile(
                title: Text('Edit Profile', style: GoogleFonts.ubuntu(),),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Screen14()),
                  );
                },
              ),
              ListTile(
                title: Text('Payment Verification', style: GoogleFonts.ubuntu(),),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PaymentVerifcationPage()),
                  );
                },
              ),
              ListTile(
                title: Text('Item 3', style: GoogleFonts.ubuntu(),), 
                onTap: () {
                  // Update the state of the app.
                  // ...
                },
              ),
              ListTile(
                title: Text('Item 4', style: GoogleFonts.ubuntu(),),
                onTap: () {
                  // Update the state of the app.
                  // ...
                },
              ),
              ListTile(
                title: Text('Item 5', style: GoogleFonts.ubuntu(),),
                onTap: () {
                  // Update the state of the app.
                  // ...
                },
              ),
            ],
          ),
        ),
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(
            (h) * (1 / 13),
          ),
          child: AppBar(
            leading: Container(
              color: Colors.white,
              width: w / 4,
              child: InkWell(
                child: Image.asset(
                  'images/million final logo with out millions.png',
                  fit: BoxFit.fitWidth,
                  alignment: Alignment.centerRight,
                ),
                onTap: () {
                  openDrawer();
                },
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(top: 10, right: 10),
                child: IconButton(
                  icon: Icon(
                    Icons.search_outlined,
                    color: Colors.black,
                  ),
                  onPressed: () async {
                    final int selected = await showSearch<int>(
                      context: context,
                      delegate: _delegate,
                    );
                    if (selected != null && selected != _lastIntegerSelected) {
                      setState(() {
                        _lastIntegerSelected = selected;
                      });
                    }
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10, right: 20, bottom:5),
                child: InkWell(
                  child: CircleAvatar(
                    child: ClipRRect(
                      child: Image.network(
                        'https://imagevars.gulfnews.com/2020/01/22/Hrithik-Roshan--3--1579703264814_16fcda6e62f_large.jpg',
                        width: w * 0.3,
                        height: w * 0.3,
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(w * 0.1),
                    ),
                    // backgroundColor: Colors.black,
                  ),
                  onTap: () {},
                ),
              )
            ],
            backgroundColor: Colors.white,
          ),
        ),
        body: pages[page],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: page,
          showUnselectedLabels: false,
          backgroundColor: primary,
          type: BottomNavigationBarType.fixed,
          fixedColor: Colors.white,
          selectedLabelStyle: GoogleFonts.ubuntu(),
          unselectedLabelStyle: GoogleFonts.ubuntu(),
          elevation: 0,
          unselectedItemColor: Colors.white,
          selectedIconTheme: IconThemeData(color: Colors.white),
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
              ),
              label: "Home",
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.video_label), label: "30s" ),
            BottomNavigationBarItem(icon: Icon(Icons.add), label: "Post video"),
            BottomNavigationBarItem(
                backgroundColor: primary,
                icon: Icon(Icons.subscriptions),
                label: "Follow"),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.photo,
                ),
                label: "Posts"),
          ],
          onTap: (index) {
            setState(() {
              page = index;
            });
          },
        ),
      ),
    );
  }
}

class _SearchDemoSearchDelegate extends SearchDelegate<int> {
  final List<String> _data = [
    "Item 1",
    "Item 2",
    "Item 3",
    "Value 1",
    "Value 2",
    "Value 3"
  ];
  // List<int>.generate(100001, (int i) => i).reversed.toList();
  final List<String> _history = <String>["Item 1", "Value 2"];

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      tooltip: 'Back',
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
        color: primary,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final Iterable<String> suggestions = query.isEmpty
        ? _history
        : _data.where((String i) => '$i'.startsWith(query));

    return _SuggestionList(
      query: query,
      suggestions: suggestions.map<String>((String i) => '$i').toList(),
      onSelected: (String suggestion) {
        query = suggestion;
        showResults(context);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final int searched = _data.indexOf(query);
    if (searched == null || !_data.contains(query)) {
      return Center(
        child: Text(
          'No results found for "$query"\n',
          style: GoogleFonts.ubuntu(),
          textAlign: TextAlign.center,
        ),
      );
    }

    return ListView(
      children: <Widget>[
        _ResultCard(
          title: _data[searched],
          index: searched,
          searchDelegate: this,
        ),
      ],
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return <Widget>[
      query.isEmpty
          ? IconButton(
              tooltip: 'Voice Search',
              icon: const Icon(
                Icons.mic,
                color: primary,
              ),
              onPressed: () {
                query = 'TODO: implement voice input';
              },
            )
          : IconButton(
              tooltip: 'Clear',
              icon: const Icon(
                Icons.clear,
                color: primary,
              ),
              onPressed: () {
                query = '';
                showSuggestions(context);
              },
            ),
    ];
  }
}

class _ResultCard extends StatelessWidget {
  const _ResultCard({this.index, this.title, this.searchDelegate});

  final int index;
  final String title;
  final SearchDelegate<int> searchDelegate;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return GestureDetector(
      onTap: () {
        searchDelegate.close(context, index);
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Text(
                title,
                style: GoogleFonts.ubuntu(),
              ),
              Text(
                '$index',
                style: GoogleFonts.ubuntu(
                    textStyle:
                        theme.textTheme.headline5.copyWith(fontSize: 72.0)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SuggestionList extends StatelessWidget {
  const _SuggestionList({this.suggestions, this.query, this.onSelected});

  final List<String> suggestions;
  final String query;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (BuildContext context, int i) {
        final String suggestion = suggestions[i];
        return ListTile(
          leading: query.isEmpty ? const Icon(Icons.history) : const Icon(null),
          title: RichText(
            text: TextSpan(
              text: suggestion.substring(0, query.length),
              style: GoogleFonts.ubuntu(
                textStyle: theme.textTheme.subtitle1
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              children: <TextSpan>[
                TextSpan(
                  text: suggestion.substring(query.length),
                  style:
                      GoogleFonts.ubuntu(textStyle: theme.textTheme.subtitle1),
                ),
              ],
            ),
          ),
          onTap: () {
            onSelected(suggestion);
          },
        );
      },
    );
  }
}
