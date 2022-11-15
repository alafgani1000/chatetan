import 'package:chatetan_duit/database/db_profile.dart';
import 'package:chatetan_duit/model/profil.dart';
import 'package:chatetan_duit/screen/jurnal_data.dart';
import 'package:chatetan_duit/screen/profil_form.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<Profil> listProfil = [];
  DbProfile db = DbProfile();
  String? name;
  bool isLoad = true;

  @override
  void initState() {
    _getProfile();
    super.initState();
  }

  Future<void> _getProfile() async {
    name = await getName();
    setState(() {
      isLoad = false;
    });
  }

  Future<String?> getName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('name');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chatetan',
      home: isLoad == true
          ? Center(
              child: CircularProgressIndicator(),
            )
          : name != null
              ? JurnalData(title: 'Chatetan')
              : const ProfileForm(),
      theme: ThemeData(
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Color.fromARGB(183, 7, 126, 142),
        ),
      ),
    );
  }
}
