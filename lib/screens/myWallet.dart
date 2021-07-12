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
  final scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
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
                                            Text('₹ '+myWallet.money.toString(),
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
                                              percent: 0.02,
                                              trailing: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 5),
                                                child: Text((myWallet.money/20).toString()+"%",
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
                                                 
                                                },
                                                style: ElevatedButton.styleFrom(
                                                    primary: myWallet.money>2000
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
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    "₹ 2078",
                                                    style: GoogleFonts.ubuntu(),
                                                  ),
                                                  Text(
                                                    "32 minutes ago",
                                                    style: GoogleFonts.ubuntu(),
                                                  )
                                                ],
                                              ),
                                              SizedBox(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.01,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    "₹ 5078",
                                                    style: GoogleFonts.ubuntu(),
                                                  ),
                                                  Text(
                                                    "30 minutes ago",
                                                    style: GoogleFonts.ubuntu(),
                                                  )
                                                ],
                                              ),
                                              SizedBox(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.01,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    "₹ 3768",
                                                    style: GoogleFonts.ubuntu(),
                                                  ),
                                                  Text(
                                                    "2 months ago",
                                                    style: GoogleFonts.ubuntu(),
                                                  )
                                                ],
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
                                      "Active Requests",
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
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  "₹ 200",
                                                  style: GoogleFonts.ubuntu(),
                                                ),
                                                Text(
                                                  "Requested",
                                                  style: GoogleFonts.ubuntu(
                                                      color: primary),
                                                )
                                              ],
                                            ),
                                            SizedBox(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.01,
                                            ),
                                            Text(
                                              'Requested 2 months ago',
                                              style: GoogleFonts.ubuntu(),
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
