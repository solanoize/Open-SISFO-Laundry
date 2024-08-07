import 'package:flutter/material.dart';

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

Widget problemWidgetException(
    {required BuildContext context, required String message}) {
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
        Text(message)
      ],
    ),
  );
}
