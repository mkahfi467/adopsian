import 'package:adopsian/screen/adopt.dart';
import 'package:adopsian/screen/browse.dart';
import 'package:adopsian/screen/offer.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Import Screen
import 'package:adopsian/screen/login.dart';
import 'package:adopsian/screen/register.dart';

String activeUser = "";

Future<String> checkUser() async {
  final prefs = await SharedPreferences.getInstance();
  String user_id = prefs.getString("user_id") ?? '';
  return user_id;
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  checkUser().then((String result) {
    if (result == '') {
      runApp(MyLogin());
    } else {
      activeUser = result;
      runApp(MyApp());
    }
  });
  // runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
      routes: {
        'login': (context) => MyLogin(),
        'register': (context) => Register(),
        'browse': (context) => Browse(),
        'offer': (context) => Offer(),
        'adopt': (context) => Adopt(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  // String _user_id = "";

  @override
  void initState() {
    super.initState();
  }

  void doLogout() async {
    // Remove user data from shared preferences
    final prefs = await SharedPreferences.getInstance();
    prefs.remove("user_id");
    // prefs.remove("user_name");
    main();
    // Navigator.popAndPushNamed(context, 'login');
  }

  Widget funDrawer() {
    return Drawer(
      elevation: 20,
      child: Column(
        children: <Widget>[
          ListTile(
            title: new Text("Log Out"),
            leading: new Icon(Icons.logout),
            onTap: () {
              // Navigator.popAndPushNamed(context, 'login');
              doLogout();
            },
          ),
          ListTile(
            title: new Text("Register"),
            leading: new Icon(Icons.app_registration_outlined),
            onTap: () {
              Navigator.popAndPushNamed(context, 'register');
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: funDrawer(),
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('ADOPSIAN', style: Theme.of(context).textTheme.headlineMedium),
            Text(
              'Adopsian sebuah aplikasi untuk memfasilitasi dan memudahkan proses adopsi hewan peliharaan. Pada aplikasi ini, user dapat menawarkan (Offer) hewan untuk diadopsi dan juga bisa mengadopsi hewan (Adopt).',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            Text("User Login ID : " + activeUser),
            const SizedBox(
              height: 16,
            ),
            SizedBox(
              height: 32.0,
              // width: double.infinity,
              width: 400,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.blue,
                ),
                onPressed: () {
                  Navigator.pushNamed(context, 'browse');
                },
                child: const Text('Browse'),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            SizedBox(
              height: 32.0,
              // width: double.infinity,
              width: 400,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.blue,
                ),
                onPressed: () {
                  Navigator.pushNamed(context, 'offer');
                },
                child: const Text('Offer'),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            SizedBox(
              height: 32.0,
              // width: double.infinity,
              width: 400,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.blue,
                ),
                onPressed: () {
                  Navigator.pushNamed(context, 'adopt');
                },
                child: const Text('Adopt'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
