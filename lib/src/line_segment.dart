import 'point.dart';

class LineSegment {
  final Point point1;
  final Point point2;

  LineSegment(this.point1, this.point2);

  static equals(LineSegment line1, LineSegment line2) =>
      ((Point.equalsTwoPoints(line1.point1, line2.point1) &&
              Point.equalsTwoPoints(line1.point2, line2.point2)) ||
          (Point.equalsTwoPoints(line1.point1, line2.point2) &&
              Point.equalsTwoPoints(line1.point2, line2.point1)));
}
