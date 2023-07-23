import 'package:flutter/material.dart';
import 'package:latihanpost/services/api_services.dart';
import 'dart:convert';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Home Page"),
        centerTitle: true,
        actions: [
          PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(
                child: Text('Profil'),
                value: 1,
              ),
              PopupMenuItem(
                child: Text('Logout'),
                value: 2,
                onTap: () {},
              ),
            ],
            onSelected: (value) async {
              if (value == 1) {
                Navigator.pushNamed(context, '/profile');
              } else {
                final services = ApiServices();
                final response = await services.logout();
                if (response.statusCode == 200) {
                  Navigator.pushReplacementNamed(
                    context,
                    '/login',
                  );
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    backgroundColor: Colors.green,
                    content: Text("Berhasil Logout"),
                    duration: Duration(seconds: 1),
                  ));
                } else {
                  final snackBar = SnackBar(
                    content: const Text('Ada Yang salah'),
                    action: SnackBarAction(
                      label: 'Undo',
                      onPressed: () {},
                    ),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }
              }
            },
          ),
        ],
      ),
      body: widgetHome(context),
    );
  }
}

Widget widgetHome(BuildContext context) {
  return Container(
    padding: const EdgeInsets.all(24),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Halo Selamat Datang di iseng apps anda sudah login masbro",
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        ElevatedButton(
          onPressed: () async {
            final services = ApiServices();
            final result = await services.getToken();
            print(result['token']);
            print(DateTime.parse(result['expired_at']!));
          },
          child: Text("get token"),
        )
      ],
    ),
  );
}
