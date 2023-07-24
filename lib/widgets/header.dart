import 'package:flutter/material.dart';

class header extends StatelessWidget {
  header({Key? key, required this.name}) : super(key: key);

  String name;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 140,
      padding: const EdgeInsets.only(
        top: 50,
        left: 20,
        bottom: 0,
        right: 20,
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment(0.8, 1),
          colors: <Color>[
            Color.fromARGB(183, 7, 126, 142),
            Color.fromARGB(183, 7, 126, 142),
            Color.fromARGB(183, 7, 126, 142),
            Color.fromARGB(183, 7, 126, 142),
            Color.fromARGB(183, 16, 157, 176),
          ],
          tileMode: TileMode.mirror,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 20,
            width: 120,
            margin: const EdgeInsets.only(right: 10),
            decoration: BoxDecoration(
              color: Colors.transparent,
              image: const DecorationImage(
                image: AssetImage('asset/image/logo1.png'),
              ),
            ),
          ),
          Text(
            name,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontFamily: 'Roboto',
            ),
          )
        ],
      ),
    );
  }
}
