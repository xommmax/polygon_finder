import 'dart:math';

class Line {
  final Point<double> p1;
  final Point<double> p2;

  const Line(this.p1, this.p2);

  @override
  bool operator ==(Object other) =>
      other is Line &&
      ((p1 == other.p1 && p2 == other.p2) ||
          (p1 == other.p2 && p2 == other.p1));

  @override
  int get hashCode => p1.hashCode ^ p2.hashCode;
}
