import 'package:flutter/material.dart';

class OptionsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  SizedBox(height: 110),
                  Column(
                    children: [
                 Row(
                    children: [
                      CircleAvatar(
                        child: ClipRRect(
                          child: Image.network(
                            'https://resize.indiatvnews.com/en/resize/newbucket/715_-/2021/02/emma-watson-1614303661.jpg',
                            width: w *1,
                            height: h * 1,
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.circular(w * 1),
                        ),
                        radius: 16,
                      ),
                      SizedBox(width: 6),
                      Text('Emma Watson',style: TextStyle(color: Colors.white),),
                      SizedBox(width: 10),
                      Icon(Icons.verified, size: 15,color: Colors.blue,),
                      ]),
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          'Follow',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),

                ],
              ),
              Column(
                children: [
                  Icon(Icons.favorite_outline,color:Colors.black,),

                  SizedBox(height: 20),
                  Icon(Icons.share,color:Colors.black,),

                  SizedBox(height: 20),
                  Icon(Icons.book,color:Colors.black,),

                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}
