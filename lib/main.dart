import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:latihanpost/page/homepage/homepage.dart';
import 'package:latihanpost/page/login/login_page.dart';
import 'package:latihanpost/page/profile/profile_page.dart';
import 'package:latihanpost/page/register/register_page.dart';

import 'onboarding.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<bool> checkToken() async {
    final storage = FlutterSecureStorage();
    final token = await storage.read(key: 'jwt');
    final expiredAt = await storage.read(key: 'expired_at');
    final currentTime = DateTime.now();

    if (token != null && expiredAt != null) {
      final expiredTime = DateTime.parse(expiredAt);
      if (currentTime.isBefore(expiredTime)) {
        return true;
      }
      return false;
    }

    return false;
  }

  Route<dynamic>? generateRoute(RouteSettings settings) {
    if (settings.name == '/home') {
      return MaterialPageRoute<dynamic>(
        builder: (context) => FutureBuilder<bool>(
          future: checkToken(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasData && snapshot.data!) {
              return HomePage();
            } else {
              return LoginPage();
            }
          },
        ),
        settings: settings,
      );
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => Onboarding(),
        '/register': (context) => RegisterPage(),
        '/login': (context) => LoginPage(),
        '/profile' : (context) => ProfilePage()
      },
      onGenerateRoute: generateRoute,
      theme: ThemeData(
          primaryColor: Color(0xFF8EE1F2),
          appBarTheme: AppBarTheme(color: Color(0xFF8EE1F2), elevation: 0),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ButtonStyle(
              backgroundColor: MaterialStatePropertyAll(
                Color(0xFF8EE1F2),
              ),
            ),
          ),
          textTheme: TextTheme(
            headline1: TextStyle(
                color: Colors.black, fontSize: 18, fontWeight: FontWeight.w600),
            headline2: TextStyle(
                color: Colors.black, fontSize: 16, fontWeight: FontWeight.w600),
            headline3: TextStyle(
                color: Colors.black, fontSize: 14, fontWeight: FontWeight.w600),
            headline4: TextStyle(
                color: Colors.black, fontSize: 13, fontWeight: FontWeight.w600),
            headline5: TextStyle(
                color: Colors.black, fontSize: 12, fontWeight: FontWeight.w600),
          )),
    );
  }
}
