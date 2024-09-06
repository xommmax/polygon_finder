import 'point.dart';

class Polygon {
  final List<Point> points;

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
}
