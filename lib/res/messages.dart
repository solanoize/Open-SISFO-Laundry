import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:open_sisfo_laundry/res/sizes.dart';
import 'package:open_sisfo_laundry/res/spacing.dart';

Widget loadingCenter() {
  return Center(child: const CircularProgressIndicator());
}

Widget successWidgetCenter({
  required context,
  required String message,
  required String label,
  required VoidCallback onPress,
}) {
  final Icon icon = Icon(
    Icons.check_circle_outline_sharp,
    size: size64,
    color: Colors.green,
  );

  final FilledButton button = FilledButton(
    onPressed: onPress,
    child: Text(label),
  );

  final Text text = Text(
    message,
    textAlign: TextAlign.center,
  );

  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        icon,
        spaceBetweenSection(),
        spaceSide(child: text),
        spaceBetweenButtonOrInput(),
        button,
      ],
    ),
  );
}

Widget errorWidgetCenter({
  required context,
  required dynamic exception,
  required String label,
  required VoidCallback onPress,
}) {
  final Icon icon = Icon(
    Icons.error_outline_outlined,
    size: size64,
    color: Colors.red,
  );

  final FilledButton button = FilledButton(
    onPressed: onPress,
    child: Text(label),
  );

  String safeInfo = "Ada sesuatu yang bermasalah saat melakukan proses ini.";

  final Text text = Text(
    kDebugMode ? exception.toString() : safeInfo,
    textAlign: TextAlign.center,
  );

  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        icon,
        spaceBetweenSection(),
        spaceSide(child: text),
        spaceBetweenButtonOrInput(),
        button,
      ],
    ),
  );
}

Widget infoWidgetStep({
  required int currentStep,
  required int totalStep,
  required String message,
}) {
  return Container(
    color: Colors.white.withOpacity(0),
    child: ListTile(
      style: ListTileStyle.list,
      leading: CircleAvatar(
        child: Text(currentStep.toString()),
      ),
      title: Text("Langkah $currentStep dari $totalStep"),
      subtitle: Text(message),
    ),
  );
}
