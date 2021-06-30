import 'package:flutter/material.dart';
import 'package:millions/constants/colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:millions/widgets/comments.dart';
import 'package:millions/model/comment_model.dart';

class Comments extends StatefulWidget {
  @override
  _CommentsState createState() => _CommentsState();
}

class _CommentsState extends State<Comments> {
  List comments = [
    Comment_Model(
        0,
        'https://i.pinimg.com/736x/2a/75/85/2a7585448874aabcb1d20e6829574994.jpg',
        'Christine',
        'super',
        '2 hours',
        '100 likes',
        false),
    Comment_Model(
        1,
        'https://media.thetab.com/blogs.dir/90/files/2018/08/portrait-face-woman-girl-female-bowl-person-people-human.jpg',
        'Rose',
        'too cooool',
        '3 hours',
        '300 likes',
        false),
    Comment_Model(
        2,
        'https://expertphotography.com/wp-content/uploads/2020/07/instagram-profile-picture-size-guide-3.jpg',
        'Sam',
        'nice',
        '4 hours',
        '5 likes',
        false),
    Comment_Model(
        3,
        'https://www.socialnetworkelite.com/hs-fs/hubfs/image2-17.jpg?width=1200&name=image2-17.jpg',
        'Rahul',
        'cooool',
        '2 hours',
        '20 likes',
        false),
    Comment_Model(
        4,
        'https://i.pinimg.com/474x/10/ca/3e/10ca3ebf744ed949b4c598795f51803b.jpg',
        'Shreya',
        'good',
        '2 hours',
        '30 likes',
        false),
    Comment_Model(
        5,
        'https://i.pinimg.com/originals/cd/d7/cd/cdd7cd49d5442e4246c4b0409b00eb39.jpg',
        'Aishwarya',
        'adipowli!!!!',
        '4 hours',
        '40 likes',
        false),
  ];

  void Like(int id) {

    setState(() {
      comments[id].liked = !comments[id].liked;
      print(id);
    });
  }

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
                decoration: InputDecoration(
                  suffixIcon: InkWell(
                    child: Icon(
                      Icons.send,
                      color: primary,
                    ),
                    onTap: () {
                      if (getcomment.text.length > 0) {
                        setState(() {
                          comments.add(
                            Comment_Model(
                                comments.length,
                                'https://imagevars.gulfnews.com/2020/01/22/Hrithik-Roshan--3--1579703264814_16fcda6e62f_large.jpg',
                                'Hrithwik',
                                getcomment.text,
                                'now',
                                '0 likes',
                                false),
                          );
                         // print(comments);
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
                      var i = comments.length - 1 - index;
                      return Comment(
                          Like,
                          comments[i].id,
                          comments[i].url,
                          comments[i].name,
                          comments[i].comment_text,
                          comments[i].time,
                          comments[i].likes_number,
                          comments[i].liked);
                    }),
              ),
            )
          ],
        ),
      ),
    );
  }
}
