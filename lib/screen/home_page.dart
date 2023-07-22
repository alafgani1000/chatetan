import 'package:chatetan_duit/database/db_profile.dart';
import 'package:chatetan_duit/model/profil.dart';
import 'package:chatetan_duit/widgets/header.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DbProfile dbProfile = DbProfile();
  List<Profil> profile = [];
  bool isLoaded = true;
  @override
  void initState() {
    // TODO: implement initState
    _getProfile();
    super.initState();
  }

  Future<void> _getProfile() async {
    var list = await dbProfile.getProfile();
    setState(() {
      profile.clear();
      list!.forEach((profil) {
        profile.add(Profil.fromMap(profil));
      });
      isLoaded = false;
    });
  }

  Widget build(BuildContext context) {
    if (isLoaded == true) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      return Scaffold(
        body: Container(
          color: Color.fromARGB(66, 247, 249, 247),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  header(
                    name: 'Hai, ${profile[0].name}',
                  )
                ],
              ),
              Expanded(
                child: CustomScrollView(
                  primary: false,
                  slivers: [],
                ),
              )
            ],
          ),
        ),
      );
    }
  }
}
