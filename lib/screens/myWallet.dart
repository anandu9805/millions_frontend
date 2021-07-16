import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:millions/constants/colors.dart';
import 'package:millions/constants/tempResources.dart';
import 'package:millions/model/walletModel.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:percent_indicator/percent_indicator.dart';

class MyWallet extends StatefulWidget {
  //const MyWallet({ Key? key }) : super(key: key);
  //final String userId;
  //MyWallet(this.userId);
  @override
  _MyWalletState createState() => _MyWalletState();
}

class _MyWalletState extends State<MyWallet> {
  bool withdrawable = false;
  String phone, email, name, profilepic;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
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

  Future<void> addRequest() async {
    try {
      await getDetails();
      return FirebaseFirestore.instance
          .collection('wallet-requests')
          .add({
            'user': altUserId,
            'date': Timestamp.now(),
            'email': email,
            'isRequestActive': true,
            'money': int.parse(_textFieldController.text),
            'name': name,
            'paid': false,
            'phoneNumber': phone,
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
                      return Text(
                        "Document does not exist",
                        style: GoogleFonts.ubuntu(fontSize: 20),
                      );
                    }

                    if (snapshot.connectionState == ConnectionState.done) {
                      Map<String, dynamic> data =
                          snapshot.data.data() as Map<String, dynamic>;
                      Wallet myWallet = Wallet.fromDoc(data);
                      myWallet.money > 2000
                          ? withdrawable = true
                          : withdrawable = false;
                      return Container(
                        child: myWallet.isActivated
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
                                                '₹ ' +
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
                                              lineHeight: 20.0,
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
                                              'You can withdraw if the total is atleast ₹2000.00',
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
                                                  if (myWallet.money > 2000) {
                                                    _displayTextInputDialog(
                                                        context);
                                                  }
                                                },
                                                style: ElevatedButton.styleFrom(
                                                    primary:
                                                        myWallet.money > 2000
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
                                                        bool deposited =
                                                            doc['deposited'];
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
                                                                  "₹ " +
                                                                      amount
                                                                          .toString(),
                                                                  style: GoogleFonts
                                                                      .ubuntu(),
                                                                ),
                                                                Text(
                                                                  DateTime.now()
                                                                              .difference(time
                                                                                  .toDate())
                                                                              .inDays ==
                                                                          0
                                                                      ? (DateTime.now().difference(time.toDate()).inHours ==
                                                                              0
                                                                          ? (DateTime.now().difference(time.toDate()).inMinutes.toString() +
                                                                              " minutes ago")
                                                                          : DateTime.now().difference(time.toDate()).inHours.toString() +
                                                                              " hours ago")
                                                                      : DateTime.now()
                                                                              .difference(time.toDate())
                                                                              .inDays
                                                                              .toString() +
                                                                          " days ago",
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
                                                                "₹ " +
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
                                                             DateTime.now()
                                                                              .difference(time
                                                                                  .toDate())
                                                                              .inDays ==
                                                                          0
                                                                      ? (DateTime.now().difference(time.toDate()).inHours ==
                                                                              0
                                                                          ? (DateTime.now().difference(time.toDate()).inMinutes.toString() +
                                                                              " minutes ago")
                                                                          : DateTime.now().difference(time.toDate()).inHours.toString() +
                                                                              " hours ago")
                                                                      : DateTime.now()
                                                                              .difference(time.toDate())
                                                                              .inDays
                                                                              .toString() +
                                                                          " days ago",
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
                                height:
                                    MediaQuery.of(context).size.height * 0.25,
                                child: Card(
                                  //color: Colors.transparent,
                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                  //margin: EdgeInsetsGeometry.infinity,
                                  child: Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Text(
                                          'Wallet Not Activated',
                                          style: GoogleFonts.ubuntu(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black),
                                        ),
                                        SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.01,
                                        ),
                                        RichText(
                                          text: TextSpan(
                                            text:
                                                'As a Millions partner, you will be eligible to earn money from your videos, posts etc and more ',
                                            style: GoogleFonts.ubuntu(
                                                fontSize: 12,
                                                color: Colors.black),
                                            children: [
                                              TextSpan(
                                                text: 'Learn More',
                                                style: GoogleFonts.ubuntu(
                                                    color: Colors.blue,
                                                    fontSize: 12),
                                                recognizer: TapGestureRecognizer()
                                                  ..onTap = () => launch(
                                                      "https://www.millions.vercel.app"),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.01,
                                        ),
                                        ElevatedButton(
                                          onPressed: () {},
                                          style: ElevatedButton.styleFrom(
                                              primary: primary),
                                          child: Text(
                                            'Request Activation',
                                            style: GoogleFonts.ubuntu(),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
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
