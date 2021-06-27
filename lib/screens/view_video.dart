import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:millions/screens/page8.dart';
import 'package:millions/widgets/comments.dart';
import '../model/comment_model.dart';

class ViewVideo extends StatefulWidget {
  @override
  _ViewVideoState createState() => _ViewVideoState();
}

class _ViewVideoState extends State<ViewVideo> {

  @override
  Widget build(BuildContext context) {



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
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
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
            padding: const EdgeInsets.only(top: 10, bottom: 10, right: 20),
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
                //backgroundColor: Colors.black,
              ),
              onTap: () {},
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
          child: Column(
        children: [
          Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.3,
              child: Image.network(
                'https://www.processmaker.com/wp-content/uploads/2019/02/f18e571b0c57a65564d6cc16acd77f83dc5e6519.jpg',
                fit: BoxFit.fitWidth,
              )),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 12.0),
                      child: Text(
                        "Former Child Actors Who",
                        style: GoogleFonts.ubuntu(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    )
                  ],
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 6.0, bottom: 6),
                      child: Text(
                        "5M Views 12 Minutes Ago",
                        style: GoogleFonts.ubuntu(
                            fontWeight: FontWeight.normal, fontSize: 12),
                      ),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.thumb_up),
                        ),
                        Text(
                          "12M Likes",
                          style: GoogleFonts.ubuntu(height: 0.3, fontSize: 10),
                        )
                      ],
                    ),
                    Column(
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.share,
                          ),
                        ),
                        Text(
                          "Share",
                          style: GoogleFonts.ubuntu(height: 0.3, fontSize: 10),
                        )
                      ],
                    ),
                    Column(
                      children: [
                        IconButton(
                            onPressed: () {},
                            icon: Icon(Icons.bookmark_outline_sharp)),
                        Text(
                          "Save",
                          style: GoogleFonts.ubuntu(height: 0.3, fontSize: 10),
                        )
                      ],
                    ),
                    Column(
                      children: [
                        IconButton(onPressed: () {}, icon: Icon(Icons.flag)),
                        Text(
                          "Report",
                          style: GoogleFonts.ubuntu(height: 0.3, fontSize: 10),
                        )
                      ],
                    )
                  ],
                ),
                Divider(
                  color: Colors.grey,
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Row(
                          children: [
                            InkWell(
                              child: CircleAvatar(
                                child: ClipRRect(
                                  child: Image.network(
                                    'https://resize.indiatvnews.com/en/resize/newbucket/715_-/2021/02/emma-watson-1614303661.jpg',
                                    width: w * 1,
                                    height: h * 1,
                                    fit: BoxFit.cover,
                                  ),
                                  borderRadius: BorderRadius.circular(w * 1),
                                ),
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Page8()),
                                );
                              },
                            ),
                            SizedBox(width: 10),
                            Text("Emma Watson")
                          ],
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        TextButton(
                          onPressed: () {},
                          child: Text("Following"),
                        )
                      ],
                    ),
                  ],
                ),
                Divider(
                  color: Colors.grey,
                  height: 30,
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 1 / 14,
                  width: double.infinity,
                  child: Text(
                    'Add banner comes here',
                    style: GoogleFonts.ubuntu(color: Colors.white),
                  ),
                  color: Colors.black,
                ),
                SizedBox(height: 10),
                Row(
                  children: [Text("4456 Comments")],
                ),
                SizedBox(height: 10),
                Container(
                  height: h / 2,
                  child:      Container(
                    height: h / 2,
                    child: ListView.builder(
                        itemCount: 5,
                        itemBuilder: (context, index) {
                          var i=comments.length - 1 - index;
                          return Comment(
                            Like,
                            index,
                              comments[i].url,
                              comments[i].name,
                              comments[i].comment_text,
                              comments[i].time,
                              comments[i].likes_number,
                              comments[i].liked
                          );
                        }),
                  )
                )
              ],
            ),
          ),
        ],
      )),
    );
  }
}
