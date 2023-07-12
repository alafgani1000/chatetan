import 'package:chatetan_duit/database/db_profile.dart';
import 'package:chatetan_duit/model/profil.dart';
import 'package:chatetan_duit/screen/jurnal_data.dart';
import 'package:chatetan_duit/screen/home_page.dart';
import 'package:chatetan_duit/screen/root_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileForm extends StatefulWidget {
  final Profil? profil;

  const ProfileForm({Key? key, this.profil}) : super(key: key);

  @override
  State<ProfileForm> createState() => _ProfileFormState();
}

class _ProfileFormState extends State<ProfileForm> {
  DbProfile db = DbProfile();

  TextEditingController? name;

  @override
  void initState() {
    // TODO: implement initState
    name = TextEditingController(
        text: widget.profil == null ? '' : widget.profil!.name);

    super.initState();
  }

  Future<void> save() async {
    await db.saveProfile(Profil(
      name: name!.text,
    ));
    await saveName(name!.text);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) {
          return const RootPage();
        },
      ),
    );
  }

  saveName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('name', name);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: name,
              decoration: InputDecoration(
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                labelText: 'Name',
                labelStyle: const TextStyle(color: Colors.black),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(
                    color: Color.fromARGB(243, 124, 109, 123),
                  ),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color.fromARGB(243, 124, 109, 123),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  primary: Color.fromARGB(243, 13, 152, 159),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  shadowColor: Colors.black,
                  minimumSize: const Size.fromHeight(40)),
              onPressed: () {
                save();
              },
              child: Text(
                'Simpan',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
