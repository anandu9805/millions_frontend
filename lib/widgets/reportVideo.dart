import 'package:flutter/material.dart';
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
  int selected = -1;
  List<String> reasons = [
    "Spam Content",
    "Explisit or Sexual Content",
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
          title: Text('Report Video'),
          backgroundColor: primary,
        ),
        body: Container(
          padding: EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 20,
              ),
              Text(
                "If you belive this content is against our guidelines, kindly report. Your identity will not be revealed",
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
                title: Text('Spam Content'),
                activeColor: Colors.red,
              ),
              RadioListTile(
                value: 1,
                groupValue: this.selected,
                onChanged: (int value) {
                  onChanged(value);
                },
                title: Text('Explisit or Sexual Content'),
                activeColor: Colors.red,
              ),
              RadioListTile(
                value: 2,
                groupValue: this.selected,
                onChanged: (int value) {
                  onChanged(value);
                },
                title: Text('Child Abuse'),
                activeColor: Colors.red,
              ),
              RadioListTile(
                value: 3,
                groupValue: this.selected,
                onChanged: (int value) {
                  onChanged(value);
                },
                title: Text('Against law'),
                activeColor: Colors.red,
              ),
              RadioListTile(
                value: 4,
                groupValue: this.selected,
                onChanged: (int value) {
                  onChanged(value);
                },
                title: Text('Harassment or bullying'),
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
                    labelStyle: TextStyle(
                      color: primary,
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
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  FlatButton(
                    onPressed: () {
                      // print(reasons[value].toString());
                      Navigator.pop(context);
                    },
                    child: Text(
                      "Back to video",
                      style: TextStyle(color: Colors.white),
                    ),
                    color: Colors.black,
                  ),
                  FlatButton(
                    onPressed: () {
                      // print(reasons[value].toString());
                      print(selectedreason);
                      ReportServices().reportVideo(widget.video,
                          selectedreason.toString(), _reportDetail.text);
                      _reportDetail.clear();
                      setState(() {
                        selected = -1;
                      });
                    },
                    child: Text(
                      "Report",
                      style: TextStyle(color: Colors.white),
                    ),
                    color: primary,
                  ),
                ],
              )
            ],
          ),
        ),
      );
}
