import 'dart:math' show Point, pow, sqrt;

import 'package:polygon_finder/src/polygon.dart';

import 'graph.dart';
import 'intersection.dart';
import 'line.dart';

class PolygonFinder {
  static List<Polygon> polygonsFromSegments(List<Line> segments) {
    Graph graph = buildGraphFromSegments(segments);
    List<List<int>> cycles = graph.findMinimumCycles();
    return polygonsFromCycles(cycles, graph);
  }

  static Graph buildGraphFromSegments(List<Line> segments) {
    Graph graph = Graph();

    // First we find all of the intersections between all of the segments
    List<Intersection> intersections = findAllIntersectionsInSegments(segments);

    // Then we filter for the segments that have more than one intersection
    List<Line> connectedSegments = [];
    List<Intersection> connectedIntersections = [];
    for (final segment in segments) {
      List<Intersection> intersectionsOnSegment = intersections
          .where((intersection) => intersection.line1 == segment || intersection.line2 == segment)
          .toList();

      if (intersectionsOnSegment.length > 1) {
        for (final intersection in intersectionsOnSegment) {
          if (!connectedIntersections.contains(intersection)) {
            connectedIntersections.add(intersection);
          }
        }
        connectedSegments.add(segment);
      }
    }

    for (final segment in connectedSegments) {
      List<Intersection> intersectionsOnSegment = connectedIntersections
          .where((intersection) => intersection.line1 == segment || intersection.line2 == segment)
          .toList();

      // For each intersection on a line, find the nearest neighbor in each direction.
      List<List<Intersection>> nearestNeighborTrios = intersectionsOnSegment.map((intersection) {
        List<Intersection?> nearestNeighborPair = [null, null];
        List<double> minimumDistancePair = [double.infinity, double.infinity];
        List<Intersection> possibleNeighbors = intersectionsOnSegment
            .where((possibleNeighbor) => possibleNeighbor != intersection)
            .toList();

        for (final possibleNeighbor in possibleNeighbors) {
          double distanceBetween = _dist(intersection.point.x, intersection.point.y,
              possibleNeighbor.point.x, possibleNeighbor.point.y);

          if (possibleNeighbor.point.x != intersection.point.x) {
            if (possibleNeighbor.point.x < intersection.point.x) {
              if (nearestNeighborPair[0] == null || distanceBetween < minimumDistancePair[0]) {
                nearestNeighborPair[0] = possibleNeighbor;
                minimumDistancePair[0] = distanceBetween;
              }
            } else if (possibleNeighbor.point.x > intersection.point.x) {
              if (nearestNeighborPair[1] == null || distanceBetween < minimumDistancePair[1]) {
                nearestNeighborPair[1] = possibleNeighbor;
                minimumDistancePair[1] = distanceBetween;
              }
            }
          } else if (possibleNeighbor.point.y != intersection.point.y) {
            if (possibleNeighbor.point.y < intersection.point.y) {
              if (nearestNeighborPair[0] == null || distanceBetween < minimumDistancePair[0]) {
                nearestNeighborPair[0] = possibleNeighbor;
                minimumDistancePair[0] = distanceBetween;
              }
            } else if (possibleNeighbor.point.y > intersection.point.y) {
              if (nearestNeighborPair[1] == null || distanceBetween < minimumDistancePair[1]) {
                nearestNeighborPair[1] = possibleNeighbor;
                minimumDistancePair[1] = distanceBetween;
              }
            }
          } else {
            continue;
          }
        }

        if (nearestNeighborPair[0] == null) {
          nearestNeighborPair[0] = intersection;
        }
        if (nearestNeighborPair[1] == null) {
          nearestNeighborPair[1] = intersection;
        }

        return [intersection, nearestNeighborPair[0]!, nearestNeighborPair[1]!];
      }).toList();

      for (final trio in nearestNeighborTrios) {
        List<Node> nodes = [];
        for (final intersection in trio) {
          Node newNode = Node(intersection.point);
          nodes.add(newNode);
          graph.addNode(newNode);
        }

        for (final node in nodes) {
          graph.addNode(node);
        }

        graph.addConnection(nodes[0], nodes[1]);
        graph.addConnection(nodes[0], nodes[2]);
      }
    }

    graph.checkForDuplicateNodes();
    graph.checkForDuplicateConnections();
    return graph;
  }

  static List<Polygon> polygonsFromCycles(List<List<int>> cycles, Graph graph) {
    List<Polygon> polygons = [];
    for (final List<int> cycle in cycles) {
      List<Point<double>> points = cycle.map((int node) => graph.nodes[node].point).toList();
      if (points.length < 3) {
        continue;
      }
      polygons.add(Polygon(points));
    }
    return polygons;
  }

  static List<Intersection> findAllIntersectionsInSegments(List<Line> segmentSet) {
    List<Intersection> intersections = [];
    for (int i = 0; i < segmentSet.length; i++) {
      for (int j = i + 1; j < segmentSet.length; j++) {
        Intersection? intersection = Intersection.findIntersection(segmentSet[i], segmentSet[j]);
        if (intersection != null) {
          bool alreadyInSet = false;
          for (int k = 0; k < intersections.length; k++) {
            if (intersections[k] == intersection) {
              alreadyInSet = true;
            }
          }
          if (!alreadyInSet) {
            intersections.add(intersection);
          }
        }
      }
    }
    return intersections;
  }

  static double _dist(double x1, double y1, double x2, double y2) {
    return sqrt(pow(x2 - x1, 2) + pow(y2 - y1, 2));
  }
}
