import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:millions/constants/colors.dart';

class PopUpMenuIcon extends StatefulWidget {
  // const PopUpMenuIcon({Key key}) : super(key: key);
  final String collection, id;
  PopUpMenuIcon(this.collection, this.id);

  @override
  _PopUpMenuIconState createState() => _PopUpMenuIconState();
}

String resultMessage;

// void delete(String coll, String docID) async {
//  await FirebaseFirestore.instance.collection(coll)
//       .doc(docID)
//       .delete();
// }

Future<void> deletenow(String coll, String doc) async{
  await FirebaseFirestore.instance.runTransaction((Transaction myTransaction) async {
     myTransaction.delete(FirebaseFirestore.instance.collection(coll)
      .doc(doc));
});
//   await delete(coll, doc).then((value) => print("deleted"));
}

// void _showToast(BuildContext context, String message) {
//   final scaffold = ScaffoldMessenger.of(context);
//   scaffold.showSnackBar(
//     SnackBar(
//       content: Text(message),
//       action: SnackBarAction(
//         label: 'OK',
//         onPressed: scaffold.hideCurrentSnackBar,
//         textColor: primary,
//       ),
//     ),
//   );
// }


//enum MenuOption {a,b,c}
class _PopUpMenuIconState extends State<PopUpMenuIcon> {
 // String _selection;
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(itemBuilder: (BuildContext context) {
      return <PopupMenuEntry>[
        // PopupMenuItem(
        //   child: Text(
        //     "Edit",
        //     style: GoogleFonts.ubuntu(),
        //   ),
        //   value: 'edit',
        // ),
        PopupMenuItem(
          child: Text("Delete", style: GoogleFonts.ubuntu()),
          value: 'delete',
        ),
      ];
    }, onSelected: (value) {
      setState(() {
        //_selection = value;
        //print(_selection);
      });
      if (value == "delete") {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(
                "Millions",
                style: GoogleFonts.ubuntu(fontWeight: FontWeight.bold),
              ),
              content: Text(
                //message,
                widget.collection == "posts"
                    ? "Do You want to delete this post?"
                    : "Do You want to delete this video?",
                style: GoogleFonts.ubuntu(),
              ),
              actions: [
                TextButton(
                  child: Text(
                    "OK",
                    style: GoogleFonts.ubuntu(color: primary),
                  ),
                  onPressed: () {
                    //print(widget.collection+"--"+widget.id);
                    deletenow(widget.collection, widget.id).whenComplete(() => print("Deleted Successfully!"));
                    
                    Navigator.of(context).pop();  
                                     
                  },
                ),
                SizedBox(
                  width: 5,
                ),
                TextButton(
                  child: Text(
                    "Cancel",
                    style: GoogleFonts.ubuntu(color: primary),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      } 
      // else {
      //   widget.collection == "posts"
      //       ? Navigator.push(
      //           context,
      //           MaterialPageRoute(builder: (context) => EditPost(widget.id)),
      //         )
      //       : Navigator.push(
      //           context,
      //           MaterialPageRoute(builder: (context) => EditVideo(widget.id)),
      //         );
      // }
    });
  }
}
