import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:millions/constants/colors.dart';
import 'package:millions/constants/tempResources.dart';

class CustomSliverAppBar extends StatefulWidget {
  @override
  _CustomSliverAppBarState createState() => _CustomSliverAppBarState();
}

class _CustomSliverAppBarState extends State<CustomSliverAppBar> {
  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  void openDrawer() {
    _drawerKey.currentState.openDrawer();
  }

  final _SearchDemoSearchDelegate _delegate = _SearchDemoSearchDelegate();

  int _lastIntegerSelected;

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;

    return SliverAppBar(
      floating: true,
      backgroundColor: Colors.white,
      // leadingWidth: 80.0,
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
            // openDrawer();
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
          padding: const EdgeInsets.only(top: 10, right: 20),
          child: InkWell(
            child: CircleAvatar(
              child: ClipRRect(
                child: Image.network(
                  altProfilePic,
                 // 'https://imagevars.gulfnews.com/2020/01/22/Hrithik-Roshan--3--1579703264814_16fcda6e62f_large.jpg',
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
