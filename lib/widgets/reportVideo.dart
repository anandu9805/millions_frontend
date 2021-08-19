import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:millions/constants/colors.dart';
import 'package:millions/model/video.dart';
import 'package:millions/services/report-services.dart';

class ReportPage extends StatefulWidget {
  final Video video;

  const ReportPage({Key key, this.video}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  void _showToast(BuildContext context, String message) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: Text(message),
        action: SnackBarAction(
          label: 'OK',
          onPressed: scaffold.hideCurrentSnackBar,
          textColor: primary,
        ),
      ),
    );
  }

  int selected = -1;
  List<String> reasons = [
    "Spam Content",
    "Explicit or Sexual Content",
    "Child Abuse",
    "Against law",
    "Harassment or bullying"
  ];
  int value;
  String selectedreason;
  void onChanged(value) {
    setState(() {
      this.selected = value;
      print('Reason: ${this.reasons[value]}');
      selectedreason = this.reasons[value];
    });
  }

  TextEditingController _reportDetail = TextEditingController();
  OutlineInputBorder outlineInputBorder = const OutlineInputBorder(
    borderSide: const BorderSide(color: primary, width: 0.0),
  );

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(
            'Report Video',
            style: GoogleFonts.ubuntu(),
          ),
          backgroundColor: primary,
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(10.0),
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 20,
                ),
                Text(
                  "If you belive this content is against our guidelines, kindly report. Your identity will not be revealed",
                  style: GoogleFonts.ubuntu(),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 20,
                ),
                RadioListTile(
                  value: 0,
                  groupValue: this.selected,
                  onChanged: (int value) {
                    onChanged(value);
                  },
                  title: Text(
                    'Spam Content',
                    style: GoogleFonts.ubuntu(),
                  ),
                  activeColor: Colors.red,
                ),
                RadioListTile(
                  value: 1,
                  groupValue: this.selected,
                  onChanged: (int value) {
                    onChanged(value);
                  },
                  title: Text(
                    'Explicit or Sexual Content',
                    style: GoogleFonts.ubuntu(),
                  ),
                  activeColor: Colors.red,
                ),
                RadioListTile(
                  value: 2,
                  groupValue: this.selected,
                  onChanged: (int value) {
                    onChanged(value);
                  },
                  title: Text(
                    'Child Abuse',
                    style: GoogleFonts.ubuntu(),
                  ),
                  activeColor: Colors.red,
                ),
                RadioListTile(
                  value: 3,
                  groupValue: this.selected,
                  onChanged: (int value) {
                    onChanged(value);
                  },
                  title: Text(
                    'Against law',
                    style: GoogleFonts.ubuntu(),
                  ),
                  activeColor: Colors.red,
                ),
                RadioListTile(
                  value: 4,
                  groupValue: this.selected,
                  onChanged: (int value) {
                    onChanged(value);
                  },
                  title: Text(
                    'Harassment or bullying',
                    style: GoogleFonts.ubuntu(),
                  ),
                  activeColor: Colors.red,
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: TextField(
                    controller: _reportDetail,
                    decoration: InputDecoration(
                      fillColor: primary,
                      focusColor: primary,
                      labelText: "Comment your reason",
                      enabledBorder: outlineInputBorder,
                      focusedBorder: outlineInputBorder,
                      labelStyle: GoogleFonts.ubuntu(
                        color: Colors.black,
                      ),
                      // hintStyle: TextStyle(color: Colors.white),
                      border: outlineInputBorder,
                    ),
                    cursorColor: primary,
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(width: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Colors.black, elevation: 0),
                      onPressed: () {
                        // print(reasons[value].toString());
                        Navigator.pop(context);
                      },
                      child: Text(
                        "CANCEL",
                        style: GoogleFonts.ubuntu(color: Colors.white),
                      ),
                    ),
                    SizedBox(width: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: primary, elevation: 0),
                      onPressed: () {
                        // print(reasons[value].toString());
                        print(selectedreason);
                        ReportServices().reportVideo(widget.video,
                            selectedreason.toString(), _reportDetail.text);
                        _showToast(context, "Video Reported Successfully");
                        _reportDetail.clear();
                        setState(() {
                          selected = -1;
                        });
                      },
                      child: Text(
                        "Report Video",
                        style: GoogleFonts.ubuntu(color: Colors.white),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      );
}
