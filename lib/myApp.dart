import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dashboard.dart';
import 'provider/auth.dart';
import 'provider/category.dart';
import 'provider/item.dart';
import 'provider/order.dart';
import 'screen/loginScreen.dart';

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isLog = false;
  getUser() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var a = await pref.getString("logged");
    // print(await pref.getString("logged"));

    if (a == "true") {
      setState(() {
        isLog = true;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUser();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => CategoryService()),
          ChangeNotifierProvider(create: ((context) => ItemService())),
          ChangeNotifierProvider(create: ((context) => OrderService())),
          ChangeNotifierProvider(create: ((context) => AuthProvider()))
        ],
        child: MaterialApp(
          title: 'Restaurant Order App',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            scaffoldBackgroundColor: Colors.white,
            // This is the theme of your application.
            //
            // TRY THIS: Try running your application with "flutter run". You'll see
            // the application has a blue toolbar. Then, without quitting the app,
            // try changing the seedColor in the colorScheme below to Colors.green
            // and then invoke "hot reload" (save your changes or press the "hot
            // reload" button in a Flutter-supported IDE, or press "r" if you used
            // the command line to start the app).
            //
            // Notice that the counter didn't reset back to zero; the application
            // state is not lost during the reload. To reset the state, use hot
            // restart instead.
            //
            // This works for code too, not just values: Most code changes can be
            // tested with just a hot reload.
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home: isLog ? DashBoardScreen() : LoginScreen(),
          // home: DashBoardScreen(),
        ));
  }
}
