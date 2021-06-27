import 'package:flutter/material.dart';
import '../constants/colors.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/comments.dart';

class Comments extends StatefulWidget {
  @override
  _CommentsState createState() => _CommentsState();
}

class _CommentsState extends State<Comments> {
  List comments = [
    'Superb!!!!!',
    'Coooollll',
    'awesome.....',
    'Good',
    'Toooo goood!!!!'
  ];

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    TextEditingController getcomment = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primary,
        title: Text('Comments'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 10,
            ),
            ListTile(
              leading: CircleAvatar(
                radius: 25,
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
              title: TextFormField(


                controller: getcomment,
                cursorColor: primary,
                validator: (value){

                },
                decoration: InputDecoration(

                  suffixIcon:  InkWell(
                    child: Icon(
                      Icons.send,
                    ),
                    onTap: () {
                      if(getcomment.text.length > 0){
                        setState(() {
                          comments.add(getcomment.text);
                          print(comments);
                        });
                      }
                    },
                  ),
                  // labelText: 'Add a comment',
                  hintText: 'Add a comment',
                  labelStyle: GoogleFonts.ubuntu(color: Colors.black),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: primary,
                      width: 1,
                    ),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(15.0),
                      topRight: Radius.circular(15.0),
                      bottomLeft: Radius.circular(15.0),
                      bottomRight: Radius.circular(15.0),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: primary,
                      width: 1,
                    ),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20.0),
                      topRight: Radius.circular(20.0),
                      bottomLeft: Radius.circular(15.0),
                      bottomRight: Radius.circular(15.0),
                    ),
                  ),
                ),
              ),
            ),
            Divider(),
            SingleChildScrollView(
              child: Container(
                height: h / 1.3,
                child: ListView.builder(
                    itemCount: comments.length,
                    itemBuilder: (context, index) {
                      return Comment(comments[comments.length - 1 - index]);
                    }),
              ),
            )
          ],
        ),
      ),
    );
  }
}
