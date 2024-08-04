import 'package:flutter/material.dart';

AppBar appBarWidget({required BuildContext context, required String title}) {
  return AppBar(
    // TRY THIS: Try changing the color here to a specific color (to
    // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
    // change color while the other colors stay the same.
    backgroundColor: Theme.of(context).colorScheme.inversePrimary,
    centerTitle: true,
    // Here we take the value from the MyHomePage object that was created by
    // the App.build method, and use it to set our appbar title.
    title: Text(title),
  );
}

Widget emptyWidget() {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(Icons.sentiment_dissatisfied_outlined),
        SizedBox(
          height: 4,
        ),
        Text("Eh, datanya kosong nih!")
      ],
    ),
  );
}

Widget problemWidget({required BuildContext context}) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          Icons.mood_bad_outlined,
          color: Theme.of(context).colorScheme.error,
        ),
        SizedBox(
          height: 8,
        ),
        Text("Duuh, ada masalah nih kayaknya!")
      ],
    ),
  );
}
