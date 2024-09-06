import 'dart:math';

import 'line.dart';

class Intersection {
  Line line1;
  Line line2;
  Point<double> point;

  Intersection(this.line1, this.line2, this.point);

  static Intersection? findIntersection(Line line1, Line line2) {
    double denominator, a, b, numerator1, numerator2;
    Point<double> intersectionPoint = const Point(0, 0);

    denominator = ((line2.p2.y - line2.p1.y) * (line1.p2.x - line1.p1.x)) -
        ((line2.p2.x - line2.p1.x) * (line1.p2.y - line1.p1.y));

    if (denominator == 0) {
      return null;
    }

    a = line1.p1.y - line2.p1.y;
    b = line1.p1.x - line2.p1.x;

    numerator1 = ((line2.p2.x - line2.p1.x) * a) - ((line2.p2.y - line2.p1.y) * b);
    numerator2 = ((line1.p2.x - line1.p1.x) * a) - ((line1.p2.y - line1.p1.y) * b);

    a = numerator1 / denominator;
    b = numerator2 / denominator;

    // If we cast these lines infinitely in both directions, they intersect here:
    intersectionPoint = Point(
        line1.p1.x + (a * (line1.p2.x - line1.p1.x)), line1.p1.y + (a * (line1.p2.y - line1.p1.y)));

    // If line1 is a segment and line2 is infinite, they intersect if:
    if (a >= 0 && a <= 1 && b >= 0 && b <= 1) {
      return Intersection(line1, line2, intersectionPoint);
    } else {
      return null;
    }
  }

  @override
  bool operator ==(Object other) =>
      other is Intersection &&
      point == other.point &&
      ((line1 == other.line1 && line2 == other.line2) ||
          (line1 == other.line2 && line2 == other.line1));

  @override
  int get hashCode => point.hashCode ^ line1.hashCode ^ line2.hashCode;
}
