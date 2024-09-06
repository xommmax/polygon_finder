import 'dart:math';

import 'package:polygon_finder/polygon_finder.dart';

void main() {
  List<Polygon> polygons = PolygonFinder.polygonsFromSegments([
    Line(Point(0, 0), Point(2, 2)),
    Line(Point(1, 2), Point(1, 0)),
    Line(Point(-1, 0), Point(1, 0)),
  ]);

  print('Number of polygons: ${polygons.length}');
  for (final polygon in polygons) {
    print(polygon); // POLYGON((1.0 1.0, 0.0 0.0, 1.0 0.0, 1.0 1.0))
  }
}
