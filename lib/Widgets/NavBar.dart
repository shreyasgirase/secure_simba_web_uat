import 'package:flutter/material.dart';

class NavBar {
  static AppBar appBar() {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.menu_rounded,
            color: Color.fromARGB(255, 138, 136, 136), size: 30),
        onPressed: () {},
      ),
      title: Container(
        padding: const EdgeInsets.fromLTRB(10, 5, 15, 5),
        // width: 80,
        height: 60,
        // padding: const EdgeInsets.fromLTRB(0, 10, 15, 10),
        child: Image.asset(
          "assets/simba_logo.JPG",
          fit: BoxFit.cover,
        ),
      ),

      centerTitle: false,
      flexibleSpace: Container(
        decoration: const BoxDecoration(color: Colors.white),
      ),
      shadowColor: Colors.grey,
      elevation: 7,
      actions: [
        Container(
          // width: 80,
          height: 58,
          padding: const EdgeInsets.fromLTRB(0, 10, 15, 10),
          child: Image.asset(
            "assets/sbi_logo.PNG",
            fit: BoxFit.cover,
          ),
        ),
      ],
      backgroundColor: Colors.white,

      // titleTextStyle: const TextStyle(
      //     color: Colors.purpleAccent,
      //     fontWeight: FontWeight.bold,
      //     fontStyle: FontStyle.italic),
    );
  }

  static Widget header(BuildContext context, String label, onPressed) {
    return Container(
      width: MediaQuery.of(context).size.width,
      // height: 35,
      decoration: const BoxDecoration(color: Color.fromRGBO(10, 4, 92, 1)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(15, 2, 0, 2),
        child: Wrap(
          // runSpacing: 10,
          crossAxisAlignment: WrapCrossAlignment.center,
          alignment: WrapAlignment.spaceBetween,
          children: [
            const Text(
              'Endorsement Management System',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              width: 150,
              child: TextButton(
                onPressed: onPressed,
                child: Row(
                  children: [
                    if (label != "")
                      const Icon(
                        Icons.arrow_back,
                        size: 20,
                        color: Colors.white,
                      ),
                    Text(
                      ' ${label}',
                      style: const TextStyle(
                          decoration: TextDecoration.underline,
                          decorationColor: Colors.white,
                          decorationThickness: 2,
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
