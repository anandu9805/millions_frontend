import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:millions/screens/home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:millions/screens/screen1.dart';
import 'package:provider/provider.dart';
import 'provider.dart';
import 'screens/shorts.dart';
import 'screens/uploadpost.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'dart:async';
import './services/dynamiclinkservice.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
//import 'package:firebase_messaging/firebase_messaging.dart';

// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   runApp(MyApp());
// }
//
// class MyApp extends StatefulWidget  {
//   @override
//   _MyAppState createState() => _MyAppState();
// }
//
// class _MyAppState extends State<MyApp> with WidgetsBindingObserver{
//   final DynamicLinkService _dynamicLinkService = DynamicLinkService();
//   Timer _timerLink;
//   @override
//   void initState() {
//
//
//     super.initState();
//     WidgetsBinding.instance.addObserver(this);
//   }
//
//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     if (state == AppLifecycleState.resumed) {
//       _timerLink = new Timer(
//         const Duration(milliseconds: 1000),
//             () {
//           _dynamicLinkService.retrieveDynamicLinks(context);
//         },
//       );
//     }
//   }
//
//   @override
//   void dispose() {
//     WidgetsBinding.instance.removeObserver(this);
//     if (_timerLink != null) {
//       _timerLink.cancel();
//     }
//     super.dispose();
//   }
//
//
//
//
//
// }











Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}
class MyApp extends StatelessWidget {

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: mainPage(),
    );
  }
}

class mainPage extends StatefulWidget {
  @override
  _mainPageState createState() => _mainPageState();
}

class _mainPageState extends State<mainPage> with WidgetsBindingObserver {
  final DynamicLinkService _dynamicLinkService = DynamicLinkService();
  Timer _timerLink;
  var isConnected =true;
  var listener;


  @override
  void initState() {
    init();
    super.initState();
    WidgetsBinding.instance.addObserver(this);


  }
  void init() async {
    print("inside upload_background");



    this.listener =
        DataConnectionChecker().onStatusChange.listen((status) async {
          switch (status) {
            case DataConnectionStatus.connected:
              setState(() {
                this.isConnected = true;
              });

              break;
            case DataConnectionStatus.disconnected:
              setState(() {
                this.isConnected = false;
              });

              break;
          }
        });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
     _dynamicLinkService.retrieveDynamicLink(context);
    if (state == AppLifecycleState.resumed
    ) {
      _timerLink = new Timer(
        const Duration(milliseconds: 1000),
            () {
          _dynamicLinkService.retrieveDynamicLink(context);
        },
      );
    }

  }

  @override
  void dispose() {

    WidgetsBinding.instance.removeObserver(this);
    if (_timerLink != null) {
      _timerLink.cancel();
    }

    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return ChangeNotifierProvider(
      create: (context) => MillionsProvider(),
      child: MaterialApp(
        routes: <String, WidgetBuilder>{
          '/': (BuildContext context) =>isConnected==true?HomePage():Center(child: Text("No net")),

        },
        debugShowCheckedModeBanner: false,
        theme: ThemeData(

          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        // home: HomePage()//Screen1(),
      ),
    );
  }
}
