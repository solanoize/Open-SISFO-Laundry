import 'package:flutter/material.dart';
import 'package:open_sisfo_laundry/res/sizes.dart';
import 'package:open_sisfo_laundry/res/spacing.dart';

Widget stepper({
  required context,
  required int count,
  required int indexSelected,
}) {
  final colorScheme = Theme.of(context).colorScheme;
  final selectedBackground = colorScheme.primary;
  final textSelectedColor = colorScheme.inversePrimary;
  final background = colorScheme.inversePrimary;

  return ListView.separated(
    scrollDirection: Axis.horizontal,
    itemCount: count,
    itemBuilder: (context, index) {
      bool isSelected = index == indexSelected;
      return CircleAvatar(
        foregroundColor: isSelected ? textSelectedColor : selectedBackground,
        backgroundColor: isSelected ? selectedBackground : background,
        child: Text('${index + 1}'),
      );
    },
    separatorBuilder: (BuildContext context, int index) {
      return spaceBetweenTabAndCard();
    },
  );
}
