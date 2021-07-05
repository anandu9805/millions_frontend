import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:millions/widgets/appbar_others.dart';
// import 'package:millions/screens/page8.dart';
import '../widgets/photos.dart';
import '../model/story.dart';

class Screen9 extends StatefulWidget {
  @override
  _Screen9State createState() => _Screen9State();
}

class _Screen9State extends State<Screen9> {
  List<Story> story = [
    Story(
        'https://i.pinimg.com/736x/2a/75/85/2a7585448874aabcb1d20e6829574994.jpg',
        'Christine'),
    Story(
        'https://media.thetab.com/blogs.dir/90/files/2018/08/portrait-face-woman-girl-female-bowl-person-people-human.jpg',
        'Rose'),
    Story(
        'https://expertphotography.com/wp-content/uploads/2020/07/instagram-profile-picture-size-guide-3.jpg',
        'Sam'),
    Story(
        'https://www.socialnetworkelite.com/hs-fs/hubfs/image2-17.jpg?width=1200&name=image2-17.jpg',
        'Rahul'),
    Story(
        'https://i.pinimg.com/474x/10/ca/3e/10ca3ebf744ed949b4c598795f51803b.jpg',
        'Shreya'),
    Story(
        'https://i.pinimg.com/originals/cd/d7/cd/cdd7cd49d5442e4246c4b0409b00eb39.jpg',
        'Aishwarya'),
    Story(
        'https://upload.wikimedia.org/wikipedia/commons/8/8c/Cristiano_Ronaldo_2018.jpg',
        'Christiano'),
    Story(
        'https://imagesvc.meredithcorp.io/v3/mm/image?url=https%3A%2F%2Fstatic.onecms.io%2Fwp-content%2Fuploads%2Fsites%2F20%2F2020%2F03%2Fana-dearmas-3.jpg',
        'Anna Marry'),
    Story(
        'https://www.businessinsider.in/thumb/msid-65957298,width-600,resizemode-4,imgsize-74717/Kevin-Systrom-is-leaving-Instagram-heres-how-he-sold-the-app-to-Facebook-for-1-billion-and-built-it-into-a-global-phenomenon.jpg',
        'Kevin'),
    Story(
        'https://static.toiimg.com/thumb/msid-81962007,width-1070,height-580,imgsize-47597,resizemode-75,overlay-toi_sw,pt-32,y_pad-40/photo.jpg',
        'Shreyas'),
    Story(
        'https://c.ndtvimg.com/2020-03/bthb68ug_virat-kohli-afp_625x300_27_March_20.jpg',
        'Virat'),
    Story(
        'https://pbs.twimg.com/profile_images/1149783043286228993/haGfGbe3.jpg',
        'MSD'),
  ];

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(children: <Widget>[
          AppBarOthers(),
          Row(children: <Widget>[
            Container(
              width: (w),
              height: h * 0.16,
              child: ListView.builder(
                itemBuilder: (context, index) {
                  return Row(children: [
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 5,
                          ),
                          child: CircleAvatar(
                            radius: w * 0.1,
                            child: ClipRRect(
                              child: Image.network(
                                story[index].url,
                                width: w * 0.16,
                                height: w * 0.16,
                                fit: BoxFit.cover,
                              ),
                              borderRadius: BorderRadius.circular(w * 0.1),
                            ),
                            backgroundColor: Colors.white,
                          ),
                        ),
                        Text(story[index].name, style: GoogleFonts.ubuntu())
                      ],
                    ),
                    SizedBox(
                      width: 5,
                    )
                  ]);
                },
                scrollDirection: Axis.horizontal,
                itemCount: story.length,
              ),
            )
          ]),
          Padding(
            padding: const EdgeInsets.only(top: 9, left: 5),
            child: Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  'Follow',
                  style:
                      GoogleFonts.ubuntu(fontSize: 25, color: Colors.black54),
                )),
          ),
          Container(
            height: (h) - (h * 1 / 11) - (h * 1 / 13) - 90.30,
            child: ListView.builder(
              itemBuilder: (context, index) {
                return Container(
                  child: Photos(index),
                );
              },
              scrollDirection: Axis.vertical,
              itemCount: 4,
            ),
          )
        ]),
      ),
    );
  }
}
