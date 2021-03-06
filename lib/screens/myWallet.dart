import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:millions/constants/colors.dart';
import 'package:millions/constants/tempResources.dart';
import 'package:millions/model/walletModel.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:percent_indicator/percent_indicator.dart';

import 'home.dart';

class MyWallet extends StatefulWidget {
  //const MyWallet({ Key? key }) : super(key: key);
  //final String userId;
  //MyWallet(this.userId);
  @override
  _MyWalletState createState() => _MyWalletState();
}

class _MyWalletState extends State<MyWallet> {
  bool withdrawable = false, noActiveRequests;
  String phone, email, name, profilepic;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
    noActiveRequests = true;
  }

  Future<void> getDetails() async {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(altUserId)
        .get()
        .then((value) {
      phone = value['phone'];
      email = value['email'];
      name = value['name'];
      profilepic = value['profilePic'];
    }).catchError((error) => print("error in retreival"));
  }

  var walletReqId =
      FirebaseFirestore.instance.collection('wallet-requests').doc();
  Future<void> addRequest() async {
    try {
      await getDetails();
      return FirebaseFirestore.instance
          .collection('wallet-requests')
          .doc(walletReqId.id)
          .set({
            'user': altUserId,
            'date': Timestamp.now(),
            'email': email,
            'isRequestActive': true,
            'money': int.parse(_textFieldController.text),
            'name': name,
            'paid': false,
            'phoneNumber': phone,
            'trascationId': walletReqId.id,
            'profilePic': profilepic, // 42
          })
          .then((value) => _showToast(context, "Request Submitted"))
          .catchError(
              (error) => _showToast(context, "Failed to place request $error"));
    } catch (e) {
      print("error");
    }
  }

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

  TextEditingController _textFieldController = TextEditingController();

  Future<void> _displayTextInputDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Millions',
            style: GoogleFonts.ubuntu(),
          ),
          content: TextField(
            cursorColor: primary,
            style: GoogleFonts.ubuntu(color: Colors.black),
            controller: _textFieldController,
            decoration: InputDecoration(
                labelText: "Enter Amount",
                focusColor: primary,
                labelStyle: GoogleFonts.ubuntu(color: Colors.black),
                fillColor: primary,
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: primary)),
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: primary))),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'CANCEL',
                style: GoogleFonts.ubuntu(color: primary),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: Text(
                'OK',
                style: GoogleFonts.ubuntu(color: primary),
              ),
              onPressed: () {
                addRequest();
                //print(_textFieldController.text);
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        key: scaffoldKey,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: FutureBuilder<DocumentSnapshot>(
                  future: FirebaseFirestore.instance
                      .collection('wallets')
                      .doc(altUserId)
                      .get(),
                  builder: (BuildContext context,
                      AsyncSnapshot<DocumentSnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return Text(
                        "Something went wrong",
                        style: GoogleFonts.ubuntu(fontSize: 20),
                      );
                    }
                    if (snapshot.hasData && !snapshot.data.exists) {
                      return Column(
                          //mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Center(
                              child: Text(
                                "Wallet does not exist",
                                style: GoogleFonts.ubuntu(fontSize: 20),
                              ),
                            ),
                          ]);
                    }

                    if (snapshot.connectionState == ConnectionState.done) {
                      Map<String, dynamic> data =
                          snapshot.data.data() as Map<String, dynamic>;
                      Wallet myWallet = Wallet.fromDoc(data);
                      myWallet.money > 2000
                          ? withdrawable = true
                          : withdrawable = false;
                      return Container(
                        child: !myWallet.isBlocked
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                    Text(
                                      "My Wallet",
                                      style: GoogleFonts.ubuntu(
                                        color: Colors.black,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.02,
                                    ),
                                    Card(
                                      clipBehavior: Clip.antiAliasWithSaveLayer,
                                      child: Padding(
                                        padding: EdgeInsets.all(20),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text('Earnings',
                                                style: GoogleFonts.ubuntu(
                                                    fontSize: 15)),
                                            SizedBox(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.01,
                                            ),
                                            Text(
                                                '??? ' +
                                                    myWallet.money.toString(),
                                                style: GoogleFonts.ubuntu(
                                                    fontSize: 40)),
                                            SizedBox(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.01,
                                            ),
                                            LinearPercentIndicator(
                                              //width:
                                              // MediaQuery.of(context).size.width * 0.65,
                                              animation: true,
                                              lineHeight: 10.0,
                                              animationDuration: 2500,
                                              percent: myWallet.money > 2000
                                                  ? 1.0
                                                  : myWallet.money / 2000,
                                              trailing: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 5),
                                                child: Text(
                                                    myWallet.money > 2000
                                                        ? "100%"
                                                        : (myWallet.money / 20)
                                                                .toString() +
                                                            "%",
                                                    style: GoogleFonts.ubuntu(
                                                        color: Colors.black)),
                                              ),
                                              linearStrokeCap:
                                                  LinearStrokeCap.roundAll,
                                              progressColor: primary,
                                            ),
                                            SizedBox(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.01,
                                            ),
                                            Text(
                                              'You can withdraw if the total is atleast ???2000.00',
                                              style: GoogleFonts.ubuntu(
                                                  fontSize: 15),
                                            ),
                                            SizedBox(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.02,
                                            ),
                                            ElevatedButton(
                                                onPressed: () {
                                                  if (myWallet.money > 2000 &&
                                                      noActiveRequests) {
                                                    _displayTextInputDialog(
                                                        context);
                                                  }
                                                },
                                                style: ElevatedButton.styleFrom(
                                                    primary:
                                                        myWallet.money > 2000 &&
                                                                noActiveRequests
                                                            ? primary
                                                            : Colors.grey),
                                                child: Text(
                                                  'Withdraw',
                                                  style: GoogleFonts.ubuntu(),
                                                ))
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.02,
                                    ),
                                    Text(
                                      "Withdraw History",
                                      style: GoogleFonts.ubuntu(
                                        color: Colors.black,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.02,
                                    ),
                                    Card(
                                      clipBehavior: Clip.antiAliasWithSaveLayer,
                                      child: Padding(
                                        padding: EdgeInsets.all(20),
                                        child: Column(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              StreamBuilder(
                                                stream: FirebaseFirestore
                                                    .instance
                                                    .collection(
                                                        'wallet-history')
                                                    .where('user',
                                                        isEqualTo:
                                                            myWallet.user)
                                                    // .orderBy("date", descending: true)
                                                    .snapshots(),
                                                builder: (BuildContext context,
                                                    AsyncSnapshot<QuerySnapshot>
                                                        snapshot) {
                                                  if (snapshot
                                                          .connectionState ==
                                                      ConnectionState.waiting) {
                                                    return Center(
                                                        child:
                                                            CircularProgressIndicator(
                                                      color: primary,
                                                    ));
                                                  }
                                                  if (snapshot
                                                      .data.docs.isEmpty) {
                                                    return Center(
                                                      child: Text(
                                                        "No transactions to show!",
                                                        style:
                                                            GoogleFonts.ubuntu(
                                                                fontSize: 15),
                                                      ),
                                                    );
                                                  }
                                                  if (snapshot.hasData) {
                                                    return new ListView(
                                                      physics:
                                                          NeverScrollableScrollPhysics(),
                                                      shrinkWrap: true,
                                                      children: snapshot
                                                          .data.docs
                                                          .map((doc) {
                                                        int amount =
                                                            doc['money'];
                                                        // bool deposited =
                                                        //   doc['deposited'];
                                                        Timestamp time =
                                                            doc['date'];

                                                        return Column(
                                                          children: [
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Text(
                                                                  "??? " +
                                                                      amount
                                                                          .toString(),
                                                                  style: GoogleFonts
                                                                      .ubuntu(),
                                                                ),
                                                                Text(
                                                                  timeago.format(
                                                                      time.toDate()),
                                                                  style: GoogleFonts
                                                                      .ubuntu(),
                                                                )
                                                              ],
                                                            ),
                                                            SizedBox(
                                                              height: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .height *
                                                                  0.01,
                                                            ),
                                                          ],
                                                        );
                                                      }).toList(),
                                                    );
                                                  } else {
                                                    return Center(
                                                      child: Text(
                                                        "Unknown Error Occured!",
                                                        style:
                                                            GoogleFonts.ubuntu(
                                                                fontSize: 15),
                                                      ),
                                                    );
                                                  }
                                                },
                                              ),
                                            ]),
                                      ),
                                    ),
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.02,
                                    ),
                                    Text(
                                      "Withdraw Requests",
                                      style: GoogleFonts.ubuntu(
                                        color: Colors.black,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.02,
                                    ),
                                    Card(
                                      clipBehavior: Clip.antiAliasWithSaveLayer,
                                      child: Padding(
                                        padding: EdgeInsets.all(20),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            StreamBuilder(
                                              stream: FirebaseFirestore.instance
                                                  .collection('wallet-requests')
                                                  .where('user',
                                                      isEqualTo: myWallet.user)
                                                  .where('isRequestActive',
                                                      isEqualTo: true)
                                                  //.orderBy("date", descending: true)
                                                  .snapshots(),
                                              builder: (BuildContext context,
                                                  AsyncSnapshot<QuerySnapshot>
                                                      snapshot) {
                                                if (snapshot.connectionState ==
                                                    ConnectionState.waiting) {
                                                  return Center(
                                                      child:
                                                          CircularProgressIndicator(
                                                    color: primary,
                                                  ));
                                                }
                                                if (snapshot
                                                    .data.docs.isEmpty) {
                                                  // setState(() {
                                                  //   noActiveRequests=true;
                                                  // });
                                                  return Center(
                                                    child: Text(
                                                      "No requests to show!",
                                                      style: GoogleFonts.ubuntu(
                                                          fontSize: 15),
                                                    ),
                                                  );
                                                }
                                                if (snapshot.hasData) {
                                                  return new ListView(
                                                    physics:
                                                        NeverScrollableScrollPhysics(),
                                                    shrinkWrap: true,
                                                    children: snapshot.data.docs
                                                        .map((doc) {
                                                      int money = doc['money'];
                                                      Timestamp time =
                                                          doc['date'];
                                                      bool isRequestActive =
                                                          doc['isRequestActive'];
                                                      return Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Text(
                                                                "??? " +
                                                                    money
                                                                        .toString(),
                                                                style: GoogleFonts
                                                                    .ubuntu(),
                                                              ),
                                                              Text(
                                                                isRequestActive
                                                                    ? "Requested"
                                                                    : "Rejected",
                                                                style: GoogleFonts
                                                                    .ubuntu(
                                                                        color:
                                                                            primary),
                                                              )
                                                            ],
                                                          ),
                                                          SizedBox(
                                                            height: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .height *
                                                                0.01,
                                                          ),
                                                          Text(
                                                            timeago.format(
                                                                time.toDate()),
                                                            style: GoogleFonts
                                                                .ubuntu(),
                                                          ),
                                                          SizedBox(
                                                            height: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .height *
                                                                0.025,
                                                          ),
                                                        ],
                                                      );
                                                    }).toList(),
                                                  );
                                                } else {
                                                  return Center(
                                                    child: Text(
                                                      "Unknown Error Occured!",
                                                      style: GoogleFonts.ubuntu(
                                                          fontSize: 15),
                                                    ),
                                                  );
                                                }
                                              },
                                            ),
                                            Divider(
                                              color: Colors.black,
                                              thickness: 0.5,
                                            ),
                                            Text(
                                              'Keep your mobile number up to date to ensure smooth communications related to transactions',
                                              style: GoogleFonts.ubuntu(),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ])
                            : Container(
                                // height: MediaQuery.of(context).size.height *
                                //     0.25,
                                width: MediaQuery.of(context).size.width,
                                child: Column(children: [
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.1,
                                  ),
                                  Image.asset(
                                    'images/error.png',
                                    width:
                                        MediaQuery.of(context).size.width * 0.6,
                                    // height: MediaQuery.of(context).size.height * 0.4,
                                  ),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.03,
                                  ),
                                  Center(
                                      child: Text(
                                    "Wallet Blocked ",
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.ubuntu(
                                      fontSize: 18,
                                      color: Colors.black87,
                                      // fontWeight: FontWeight.bold
                                    ),
                                  )),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.01,
                                  ),
                                  Center(
                                      child: Text(
                                    "Wallet is currently blocked " +
                                        ". Please come back later.",
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.ubuntu(
                                      fontSize: 10,
                                      color: Colors.grey,
                                      // fontWeight: FontWeight.bold
                                    ),
                                  )),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.05,
                                  ),
                                  Center(
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          primary: primary, elevation: 0),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => HomePage()),
                                        );
                                      },
                                      child: Text(
                                        "Go Home",
                                        style: GoogleFonts.ubuntu(fontSize: 15),
                                      ),
                                    ),
                                  )
                                ])),
                      );
                    }
                    return Center(
                      child: CircularProgressIndicator(
                        color: primary,
                      ),
                    );
                  }),
            ),
          ),
        ));
  }
}

// class TimeAgo{
//   static String timeAgoSinceDate(DateTime notificationDate, {bool numericDates = true}) {
//    // DateTime notificationDate = DateFormat("dd-MM-yyyy h:mma").parse(dateString);
//     final date2 = DateTime.now();
//     final difference = date2.difference(notificationDate);

//     if (difference.inDays > 8) {
//       return dateString;
//     } else if ((difference.inDays / 7).floor() >= 1) {
//       return (numericDates) ? '1 week ago' : 'Last week';
//     } else if (difference.inDays >= 2) {
//       return '${difference.inDays} days ago';
//     } else if (difference.inDays >= 1) {
//       return (numericDates) ? '1 day ago' : 'Yesterday';
//     } else if (difference.inHours >= 2) {
//       return '${difference.inHours} hours ago';
//     } else if (difference.inHours >= 1) {
//       return (numericDates) ? '1 hour ago' : 'An hour ago';
//     } else if (difference.inMinutes >= 2) {
//       return '${difference.inMinutes} minutes ago';
//     } else if (difference.inMinutes >= 1) {
//       return (numericDates) ? '1 minute ago' : 'A minute ago';
//     } else if (difference.inSeconds >= 2) {
//       return '${difference.inSeconds} seconds ago';
//     } else {
//       return 'Just now';
//     }
//   }

// } 