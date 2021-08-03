import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:millions/screens/complete_profile.dart';
import 'package:millions/screens/home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:millions/screens/noNetConnection.dart';
import 'package:millions/screens/screen1.dart';
import 'package:provider/provider.dart';
import 'provider.dart';
import 'screens/shorts.dart';
import 'screens/uploadpost.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'dart:async';
import './services/dynamiclinkservice.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import './screens/screen11.dart';
import './services/local_notification_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import './screens/view_video.dart';


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

//to get the message data while app in background
Future<void> backgroundHandler(RemoteMessage message) async {
  print(message.data.toString());
  print(message.notification.title);
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(backgroundHandler);
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
  var isConnected = true;
  var listener;

  @override
  void initState() {
    init();
    LocalNotificationService.initialize(context);
    //to get message data while app is in terminated state and opened by clicking on the notification
    FirebaseMessaging.instance.getInitialMessage().then((message){
      print("//to get message data while app is in terminated state and opened by clicking on the notification");
      if(message!=null){

        if(message.data["screen"]=="videos")
        {
          //-------------------------------------------------------------------------------------------------
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) =>ViewVideo(id:message.data["itemId"],video:null)),
          );
        }
        if(message.data["screen"]=="posts")
        {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Screen11(message.data["itemId"])),
          );
        }
        if(message.data["screen"]=="channel")
        {
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(builder: (context) => Screen11(null)),
          // );

        }

      }
    });
    //to get message data while app in foreground
    FirebaseMessaging.onMessage.listen((message) {
      print("to get message data while app in foreground");
      if (message.notification != null) {


      }
      LocalNotificationService.display(message);
    });
    //to get message data while app is in background and opened by clicking on the notification
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
print("to get message data while app is in background and opened by clicking on the notification");
      if(message.data["screen"]=="videos")
        {
          //-------------------------------------------------------------------------------------------------
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) =>ViewVideo(id:message.data["itemId"],video:null)),
          );
        }
      if(message.data["screen"]=="posts")
      {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Screen11(message.data["itemId"])),
        );
      }
      if(message.data["screen"]=="channel")
      {
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) => Screen11(null)),
        // );

      }

    });
    super.initState();
    WidgetsBinding.instance.addObserver(this);
   
  }

  void init() async {
    print("checking internet connection");

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
    if (state == AppLifecycleState.resumed) {
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
          '/': (BuildContext context) => isConnected == true
              ? HomePage() //Screen1()
              : NoInternet(),
          'Posts': (BuildContext context) => Screen11(null),
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
