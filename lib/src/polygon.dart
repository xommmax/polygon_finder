import 'dart:math';

import 'package:collection/collection.dart';

class Polygon {
  final List<Point<double>> points;

  Polygon(this.points);

  @override
  String toString() {
    String result = "POLYGON((";
    for (int i = 0; i < points.length; i++) {
      result += "${points[i].x} ${points[i].y}";
      if (i != points.length - 1) {
        result += ", ";
      }
    }
    result += "))";
    return result;
  }

  @override
  operator ==(other) =>
      other is Polygon && const UnorderedIterableEquality().equals(points, other.points);

  @override
  int get hashCode => points.hashCode;
}
