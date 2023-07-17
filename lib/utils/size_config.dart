import 'package:flutter/material.dart';

double getProportionateHeight(double height, BoxConstraints constraints) {
  return (constraints.maxHeight / 926) * height;
}

double getProportionateWidth(double width, BoxConstraints constraints) {
  return (constraints.maxWidth / 428) * width;
}
