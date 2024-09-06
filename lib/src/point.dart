class Point {
  final double x;
  final double y;

  Point(this.x, this.y);

  @override
  bool operator ==(Object other) => (other is Point && x == other.x && y == other.y);

  @override
  int get hashCode => x.hashCode ^ y.hashCode;

  static bool equalsTwoPoints(Point point1, Point point2) =>
      (point1.x == point2.x && point1.y == point2.y);
}
