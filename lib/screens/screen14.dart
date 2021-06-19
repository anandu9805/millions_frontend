import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Screen14 extends StatefulWidget {
  @override
  _Screen14State createState() => _Screen14State();
}

class _Screen14State extends State<Screen14> {
  final _focusnode1 = FocusNode();

  final _focusnode2 = FocusNode();

  final _focusnode3 = FocusNode();

  final _focusnode4 = FocusNode();

  final _focusnode5 = FocusNode();

  final _focusnode6 = FocusNode();

  final _form = GlobalKey<FormState>();

  @override
  void dispose() {
    _focusnode2.dispose();
    _focusnode3.dispose();
    _focusnode4.dispose();
    _focusnode5.dispose();
    _focusnode6.dispose();
    super.dispose();
  }

  void _saveall() {
    _form.currentState.save();
  }

  Widget build(BuildContext context) {
    // var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        leading: Container(
          color: Colors.white,
          width: w / 4,
          child: Image.asset(
            'images/million final logo with out millions.png',
            fit: BoxFit.fitWidth,
            alignment: Alignment.centerRight,
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
                onPressed: () {
                  //go to search screen
                }),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10, right: 20),
            child: CircleAvatar(
              backgroundColor: Colors.black,
            ),
          )
        ],
        backgroundColor: Colors.white,
      ),
      body: Form(
        key: _form,
        child: ListView(children: <Widget>[
          Padding(
              padding:
                  EdgeInsets.only(left: 20, top: 20, bottom: 20, right: 20),
              child: Text(
                'Edit Account',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 30,
                ),
              )),
          Padding(
            padding:
                const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 20),
            child: TextFormField(
              decoration: InputDecoration(
                  labelText: 'Name',
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 1.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 1.0),
                  )),
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (_) {
                FocusScope.of(context).requestFocus(_focusnode1);
              },
              onSaved: (val) {},
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 20),
            child: TextFormField(
              focusNode: _focusnode1,
              decoration: InputDecoration(
                  labelText: 'Email',
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 1.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 1.0),
                  )),
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (_) {
                FocusScope.of(context).requestFocus(_focusnode2);
              },
              onSaved: (val) {},
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 20),
            child: TextFormField(
              focusNode: _focusnode2,
              decoration: InputDecoration(
                  labelText: 'Sex',
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 1.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 1.0),
                  )),
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (_) {
                FocusScope.of(context).requestFocus(_focusnode3);
              },
              onSaved: (val) {},
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 20),
            child: TextFormField(
              focusNode: _focusnode3,
              decoration: InputDecoration(
                  labelText: 'Place',
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 1.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 1.0),
                  )),
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (_) {
                FocusScope.of(context).requestFocus(_focusnode4);
              },
              onSaved: (val) {},
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 20),
            child: TextFormField(
              focusNode: _focusnode4,
              decoration: InputDecoration(
                  labelText: 'District',
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 1.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 1.0),
                  )),
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (_) {
                FocusScope.of(context).requestFocus(_focusnode5);
              },
              onSaved: (val) {},
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 20),
            child: TextFormField(
              focusNode: _focusnode5,
              decoration: InputDecoration(
                  labelText: 'State',
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 1.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 1.0),
                  )),
              textInputAction: TextInputAction.next,
              onSaved: (val) {},
            ),
          ),
          Padding(
              padding: const EdgeInsets.only(
                left: 20,
                right: 20,
                top: 10,
              ),
              child: GestureDetector(
                onTap: () {_saveall();},
                child: Container(
                  decoration: BoxDecoration(shape:BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(5),
                    color: Color(0xffa31545),
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(
                        left: 20, right: 20, top: 10, bottom: 10),
                    child: Text(
                      "Save",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ))
        ]),
      ),
    );
  }
}
