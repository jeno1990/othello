import 'package:flutter/material.dart';
import 'package:othello/utils/constants.dart';

BorderRadius getBorderRadius(int row, int col) {
  if (row == 1 && col == 1) {
    return BorderRadius.only(bottomRight: Radius.circular(borderRadiusWide));
  } else if (row == 2 && col == 1) {
    return BorderRadius.only(topRight: Radius.circular(borderRadiusWide));
  } else if (row == 2 && col == 2) {
    return BorderRadius.only(topLeft: Radius.circular(borderRadiusWide));
  } else if (row == 1 && col == 2) {
    return BorderRadius.only(bottomLeft: Radius.circular(borderRadiusWide));
  } else if (row == 5 && col == 5) {
    return BorderRadius.only(bottomRight: Radius.circular(borderRadiusWide));
  } else if (row == 6 && col == 5) {
    return BorderRadius.only(topRight: Radius.circular(borderRadiusWide));
  } else if (row == 6 && col == 6) {
    return BorderRadius.only(topLeft: Radius.circular(borderRadiusWide));
  } else if (row == 5 && col == 6) {
    return BorderRadius.only(bottomLeft: Radius.circular(borderRadiusWide));
  } else if (row == 1 && col == 5) {
    return BorderRadius.only(bottomRight: Radius.circular(borderRadiusWide));
  } else if (row == 2 && col == 5) {
    return BorderRadius.only(topRight: Radius.circular(borderRadiusWide));
  } else if (row == 2 && col == 6) {
    return BorderRadius.only(topLeft: Radius.circular(borderRadiusWide));
  } else if (row == 1 && col == 6) {
    return BorderRadius.only(bottomLeft: Radius.circular(borderRadiusWide));
  } else if (row == 5 && col == 1) {
    return BorderRadius.only(bottomRight: Radius.circular(borderRadiusWide));
  } else if (row == 6 && col == 1) {
    return BorderRadius.only(topRight: Radius.circular(borderRadiusWide));
  } else if (row == 6 && col == 2) {
    return BorderRadius.only(topLeft: Radius.circular(borderRadiusWide));
  } else if (row == 5 && col == 2) {
    return BorderRadius.only(bottomLeft: Radius.circular(borderRadiusWide));
  }
  return BorderRadius.circular(borderRadiusNarrow);
}
