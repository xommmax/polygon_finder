import 'dart:math';

import 'package:polygon_finder/polygon_finder.dart';
import 'package:test/test.dart';

void main() {
  group('A group of tests', () {
    setUp(() {});

    test('First Test', () {
      List<Polygon> polygons = PolygonFinder.polygonsFromSegments([
        Line(Point(0, 0), Point(2, 2)),
        Line(Point(1, 2), Point(1, 0)),
        Line(Point(-1, 0), Point(1, 0)),
      ]);

      final expectedPolygon = Polygon([
        Point(1, 1),
        Point(0, 0),
        Point(1, 0),
        Point(1, 1),
      ]);

      expect(polygons, [expectedPolygon]);
    });
  });
}
