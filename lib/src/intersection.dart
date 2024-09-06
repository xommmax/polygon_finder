import 'line_segment.dart';
import 'point.dart';

class Intersection {
  LineSegment line1;
  LineSegment line2;
  Point point;

  Intersection(this.line1, this.line2, this.point);

  static Intersection? findIntersection(LineSegment line1, LineSegment line2) {
    double denominator, a, b, numerator1, numerator2;
    Point intersectionPoint = Point(0, 0);

    denominator = ((line2.point2.y - line2.point1.y) * (line1.point2.x - line1.point1.x)) -
        ((line2.point2.x - line2.point1.x) * (line1.point2.y - line1.point1.y));

    if (denominator == 0) {
      return null;
    }

    a = line1.point1.y - line2.point1.y;
    b = line1.point1.x - line2.point1.x;

    numerator1 = ((line2.point2.x - line2.point1.x) * a) - ((line2.point2.y - line2.point1.y) * b);
    numerator2 = ((line1.point2.x - line1.point1.x) * a) - ((line1.point2.y - line1.point1.y) * b);

    a = numerator1 / denominator;
    b = numerator2 / denominator;

    // If we cast these lines infinitely in both directions, they intersect here:
    intersectionPoint = Point(line1.point1.x + (a * (line1.point2.x - line1.point1.x)),
        line1.point1.y + (a * (line1.point2.y - line1.point1.y)));

    // If line1 is a segment and line2 is infinite, they intersect if:
    if (a >= 0 && a <= 1 && b >= 0 && b <= 1) {
      print('Intersection: $intersectionPoint');
      return Intersection(line1, line2, intersectionPoint);
    } else {
      print('Intersection: null');

      return null;
    }
  }

  static bool equals(Intersection intersection1, Intersection intersection2) {
    return Point.equalsTwoPoints(intersection1.point, intersection2.point) &&
        ((LineSegment.equals(intersection1.line1, intersection2.line1) &&
                LineSegment.equals(intersection1.line2, intersection2.line2)) ||
            (LineSegment.equals(intersection1.line1, intersection2.line2) &&
                LineSegment.equals(intersection1.line2, intersection2.line1)));
  }
}
