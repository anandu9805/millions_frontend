import 'package:flutter/material.dart';
import 'package:millions/screens/page8.dart';
import 'package:millions/widgets/comments.dart';

class ViewVideo extends StatefulWidget {
  @override
  _ViewVideoState createState() => _ViewVideoState();
}

class _ViewVideoState extends State<ViewVideo> {
  @override
  Widget build(BuildContext context) {
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
                backgroundColor: Colors.black,
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Page8()),
                );
              },
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      width: MediaQuery.of(context).size.width * 0.91,
                      height: MediaQuery.of(context).size.height * 0.3,
                      child: Image.asset(
                        'images/millionlogo.png',
                        fit: BoxFit.fitWidth,
                      )),
                ],
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: Text(
                      "Former Child Actors Who",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
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
                      style: TextStyle(
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
                        style: TextStyle(height: 0.3, fontSize: 10),
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
                        style: TextStyle(height: 0.3, fontSize: 10),
                      )
                    ],
                  ),
                  Column(
                    children: [
                      IconButton(
                          onPressed: () {}, icon: Icon(Icons.bookmark_add)),
                      Text(
                        "Save",
                        style: TextStyle(height: 0.3, fontSize: 10),
                      )
                    ],
                  ),
                  Column(
                    children: [
                      IconButton(onPressed: () {}, icon: Icon(Icons.flag)),
                      Text(
                        "Report",
                        style: TextStyle(height: 0.3, fontSize: 10),
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
                              backgroundColor: Colors.black,
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
                          Text("Cooper")
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
                  style: TextStyle(color: Colors.white),
                ),
                color: Colors.black,
              ),
              SizedBox(height: 10),
              Row(
                children: [Text("4456 Comments")],
              ),
              SizedBox(height: 10),
              Comment(),
              Comment(),
              Comment(),
              Comment()
            ],
          ),
        ),
      ),
    );
  }
}
