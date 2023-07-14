import 'package:chatetan_duit/widgets/header.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
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
                  name: 'Hai, Ghani',
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
