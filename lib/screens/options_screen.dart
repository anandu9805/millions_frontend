import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:millions/constants/colors.dart';

class OptionsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    // bool liked = false;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Spacer(),
          SizedBox(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Column(
                  children: [
                    Row(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              child: ClipRRect(
                                child: Image.network(
                                  'https://resize.indiatvnews.com/en/resize/newbucket/715_-/2021/02/emma-watson-1614303661.jpg',
                                  width: w * 1,
                                  height: h * 1,
                                  fit: BoxFit.cover,
                                ),
                                borderRadius: BorderRadius.circular(w * 1),
                              ),
                              radius: 16,
                            ),
                          ],
                        ),
                        SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Emma Watsn',
                                  style:
                                      GoogleFonts.ubuntu(color: Colors.white),
                                ),
                                SizedBox(width: 10),
                                Icon(
                                  Icons.verified,
                                  size: 15,
                                  color: Colors.blue,
                                ),
                              ],
                            ),
                            SizedBox(height: 5),
                            Row(
                              children: [
                                InkWell(
                                  onTap: () {},
                                  child: Text(
                                    'Follow',
                                    style: GoogleFonts.ubuntu(
                                        color: Colors.white,
                                        height: 1,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                        SizedBox(width: 6),
                      ],
                    ),
                  ],
                ),
                Column(
                  children: [
                    Icon(
                      Icons.thumb_up,
                      color: primary,
                    ),
                    SizedBox(height: 20),
                    Icon(
                      Icons.share,
                      color: Colors.white,
                    ),
                    SizedBox(height: 20),
                    Icon(
                      Icons.bookmark_add_outlined,
                      color: Colors.white,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
