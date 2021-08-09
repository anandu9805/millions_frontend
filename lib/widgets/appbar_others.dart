import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:millions/constants/colors.dart';
import 'package:millions/constants/tempResources.dart';
import 'package:millions/provider.dart';
import 'package:millions/screens/explore.dart';
import 'package:millions/screens/myWallet.dart';
import 'package:millions/screens/page8.dart';
import 'package:millions/screens/screen14.dart';
import 'package:millions/screens/searchPage..dart';
import 'package:millions/services/userService.dart';
import 'package:provider/provider.dart';

class AppBarOthers extends StatefulWidget {
  @override
  _AppBarOthersState createState() => _AppBarOthersState();
}

class _AppBarOthersState extends State<AppBarOthers> {
  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  void openDrawer() {
    _drawerKey.currentState.openDrawer();
  }

  final _SearchDemoSearchDelegate _delegate = _SearchDemoSearchDelegate();

  int _lastIntegerSelected;

  void _showPopupMenu(Offset offset) async {
    await showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
          offset.dx,
          offset.dy,
          MediaQuery.of(context).size.width - offset.dx,
          MediaQuery.of(context).size.height - offset.dy),
      items: [
        PopupMenuItem(
          child: Text("My Channel", style: GoogleFonts.ubuntu()),
          value: 'mychannel',
        ),
        PopupMenuItem(
          child: Text(
            "My Account",
            style: GoogleFonts.ubuntu(),
          ),
          value: 'editprofile',
        ),
        PopupMenuItem(
          child: Text("My Wallet", style: GoogleFonts.ubuntu()),
          value: 'mywallet',
        ),
        PopupMenuItem(
          child: Text("Logout", style: GoogleFonts.ubuntu()),
          value: 'logout',
        ),
      ],
      elevation: 8.0,
    ).then((value) {
      if (value != null) {
        if (value == 'logout') {
          final millionsprovider =
              Provider.of<MillionsProvider>(context, listen: false);
          millionsprovider.logout(context);
        } else if (value == 'mywallet') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MyWallet()),
          );
        } else if (value == 'mychannel') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Page8(altUserId)),
          );
        } else if (value == 'editprofile') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Screen14()),
          );
        }
      }

// NOTE: even you didnt select item this method will be called with null of value so you should call your call back with checking if value is not null
    });
  }

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;

    return AppBar(
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
          padding: const EdgeInsets.only(
            top: 10,
          ),
          child: IconButton(
            icon: Icon(
              Icons.search_outlined,
              color: primary,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SearchPage()),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10, right: 10),
          child: IconButton(
            icon: Icon(
              Icons.explore,
              color: primary,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Explore()),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10, right: 20),
          child: FutureBuilder(
              future: UserServices().getUserDetails(altUserId),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return GestureDetector(
                    onTapDown: (TapDownDetails details) {
                      _showPopupMenu(details.globalPosition);
                    },
                    child: CircleAvatar(
                      child: ClipRRect(
                        child: Image.network(
                          snapshot.data.toString(),
                          //reels_objects[index].profilePic,
                          width: w * 1,
                          height: w * 1,
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.circular(w * 1),
                      ),
                      radius: 25,
                    ),
                    /*CircleAvatar(radius: 20,
                            child: ClipRRect(
                              child: Image.network(
                                snapshot.data.toString(),
                                fit: BoxFit.cover,
                              ),
                              borderRadius: BorderRadius.circular(w * 0.1),
                            ),
                            //backgroundColor: Colors.black,
                          ),*/
                  );
                } else {
                  return GestureDetector(
                    onTapDown: (TapDownDetails details) {
                      _showPopupMenu(details.globalPosition);
                    },
                    child: InkWell(
                      child: CircleAvatar(
                        radius: w * 0.3,
                        backgroundColor: Colors.black,
                      ),
                    ),
                  );
                }
              }),
        )
      ],
      backgroundColor: Colors.white,
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
