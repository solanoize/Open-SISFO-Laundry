import 'package:flutter/material.dart';
import 'package:open_sisfo_laundry/res/sizes.dart';

SizedBox spaceAfterHeader() {
  return SizedBox(
    height: size14,
  );
}

SizedBox spaceEnd() {
  return SizedBox(
    height: size14,
  );
}

Padding spaceSide({required Widget child}) {
  /// https://www.instagram.com/p/C9SjDdno4U_/?img_index=4
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: size16),
    child: child,
  );
}

Padding spaceBetweenTitleAndContent({required Widget child}) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: size16),
    child: child,
  );
}

SizedBox spaceBetweenSection([double space = size32]) {
  return SizedBox(
    height: space,
  );
}

SizedBox spaceBetweenTabAndCard() {
  return SizedBox(
    width: size12,
  );
}

SizedBox spaceBetweenButtonOrInput() {
  return SizedBox(
    height: size12,
  );
}

Expanded fillSpace() {
  return Expanded(child: Container());
}
