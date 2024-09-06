import 'point.dart';

class Graph {
  List<Node> nodes = [];
  List<Connection> connections = [];

  void checkForDuplicateNodes() {
    for (int i = 0; i < nodes.length; i++) {
      for (int j = i + 1; j < nodes.length; j++) {
        if (nodes[i].equals(nodes[j])) {
          print("DUPLICATE NODES, $i and $j");
        }
      }
    }
  }

  void checkForDuplicateConnections() {
    for (int i = 0; i < connections.length; i++) {
      for (int j = i + 1; j < connections.length; j++) {
        if (connections[i].equals(connections[j])) {
          print("DUPLICATE CONNECTIONS, $i and $j");
        }
      }
    }
  }

  List<List<int>> getAdjacencyList() {
    List<List<int>> adjacencyList = [];
    for (int i = 0; i < nodes.length; i++) {
      adjacencyList.add([]);
      Node node = nodes[i];
      node.id = i;
      Set<Node> connectedNodes = getConnectedNodes(node);
      for (final node in connectedNodes) {
        adjacencyList[i].add(nodes.indexOf(node));
      }
    }
    return adjacencyList;
  }

  Set<Node> getConnectedNodes(Node node) {
    List<Connection> myConnections = connections
        .where((connection) => connection.node1 == node || connection.node2 == node)
        .toList();
    Set<Node> connectedNodes = {};
    for (final connection in myConnections) {
      connectedNodes.add(connection.node1);
      connectedNodes.add(connection.node2);
    }
    connectedNodes.remove(node);
    return connectedNodes;
  }

  List<Connection> getConnectionsFromNode(Node node) {
    return connections
        .where((connection) => connection.node1 == node || connection.node2 == node)
        .toList();
  }

  List<Node> getNeighboringNodes(Node node) {
    List<Connection> nodeConnections = getConnectionsFromNode(node);
    List<Node> neighboringNodes = [];
    for (final nodeConnection in nodeConnections) {
      if (nodeConnection.node1 != node) {
        neighboringNodes.add(nodeConnection.node1);
      } else if (nodeConnection.node2 != node) {
        neighboringNodes.add(nodeConnection.node2);
      }
    }
    return neighboringNodes;
  }

  bool isConnected(Node node1, Node node2) {
    return connections.any((connection) =>
        (connection.node1 == node1 && connection.node2 == node2) ||
        (connection.node2 == node1 && connection.node1 == node2));
  }

  bool addConnection(Node? node1, Node? node2) {
    if (node1 == null || node2 == null) {
      return false;
    }

    if (node1.equals(node2)) {
      return false;
    }

    List<Node> node1Matches =
        nodes.where((node) => Point.equalsTwoPoints(node.point, node1.point)).toList();
    List<Node> node2Matches =
        nodes.where((node) => Point.equalsTwoPoints(node.point, node2.point)).toList();

    if (node1Matches.length > 1) {
      print("Too many matches for node 1. length = ${node1Matches.length}");
      return false;
    }

    if (node2Matches.length > 1) {
      print("Too many matches for node 1. length = ${node2Matches.length}");
      return false;
    }

    if (node1Matches.isEmpty) {
      print("No matches for node 1, doing nothing");
      return false;
    }

    if (node2Matches.isEmpty) {
      print("No matches for node 2, doing nothing");
      return false;
    }

    Connection newConnection = Connection(node1Matches[0], node2Matches[0]);

    List<Connection> duplicateConnections =
        connections.where((connection) => connection.equals(newConnection)).toList();

    if (duplicateConnections.length > 1) {
      return false;
    } else if (duplicateConnections.length == 1) {
      return false;
    } else {
      connections.add(newConnection);
      return true;
    }
  }

  void addNode(Node newNode) {
    List<Node> duplicateNodes =
        nodes.where((node) => Point.equalsTwoPoints(newNode.point, node.point)).toList();

    if (duplicateNodes.length > 1) {
      print("TODO: HANDLE THIS. THIS SHOULD NOT BE HAPPENING");
    }

    if (duplicateNodes.isEmpty) {
      nodes.add(newNode);
    }
  }

  List<List<int>> findMinimumCyclesFromSource(int adjacencyListSourceIndex) {
    List<List<int>> adjacencyList = getAdjacencyList();
    List<int> neighbors = adjacencyList[adjacencyListSourceIndex];
    List<List<int>> paths = [];
    for (int i = 0; i < neighbors.length; i++) {
      List<int> path = [adjacencyListSourceIndex];
      int startingNeighborIndex = neighbors[i];
      List<List<int>> tmpAdjacencyList = List.from(adjacencyList);
      tmpAdjacencyList[startingNeighborIndex] = tmpAdjacencyList[startingNeighborIndex]
          .where((nodeIndex) => nodeIndex != adjacencyListSourceIndex)
          .toList();
      path.addAll(Graph.findShortestPath(
          tmpAdjacencyList, startingNeighborIndex, adjacencyListSourceIndex));
      paths.add(path);
    }
    return paths;
  }

  List<List<int>> findMinimumCycles() {
    List<List<int>> adjacencyList = getAdjacencyList();
    List<List<int>> cycles = [];
    for (int i = 0; i < adjacencyList.length; i++) {
      List<List<int>> paths = findMinimumCyclesFromSource(i);
      cycles.addAll(paths);
    }

    List<List<int>> uniqueCycles = [];
    for (int i = 0; i < cycles.length; i++) {
      if (uniqueCycles
          .where((cycle) => Graph.doArraysContainSameElements(cycle, cycles[i]))
          .isEmpty) {
        uniqueCycles.add(cycles[i]);
      }
    }

    List<List<int>> edgePairs = [];
    Map<String, int> edgePairCount = {};
    for (int i = 0; i < uniqueCycles.length; i++) {
      List<int> cycle = uniqueCycles[i];
      for (int j = 1; j < cycle.length; j++) {
        List<int> edgePair = [];
        if (cycle[j - 1] < cycle[j]) {
          edgePair = [cycle[j - 1], cycle[j]];
        } else {
          edgePair = [cycle[j], cycle[j - 1]];
        }

        String edgeKey = "${edgePair[0]},${edgePair[1]}";
        if (edgePairCount.containsKey(edgeKey)) {
          edgePairCount[edgeKey] = edgePairCount[edgeKey]! + 1;
        } else {
          edgePairCount[edgeKey] = 1;
        }
        edgePairs.add(edgePair);
      }
    }

    List<List<int>> edgesOnlyUsedOnce = [];
    for (final edgePair in edgePairs) {
      String edgeKey = "${edgePair[0]},${edgePair[1]}";
      if (edgePairCount[edgeKey] == 1) {
        edgesOnlyUsedOnce.add(edgePair);
      }
    }

    List<List<int>> leftoverAdjacencyList = List.generate(nodes.length, (index) => []);
    for (final edge in edgesOnlyUsedOnce) {
      leftoverAdjacencyList[edge[0]].add(edge[1]);
      leftoverAdjacencyList[edge[1]].add(edge[0]);
    }

    List<List<int>> extraPaths = [];
    for (int i = 0; i < leftoverAdjacencyList.length; i++) {
      List<int>? neighbors = leftoverAdjacencyList[i];
      if (neighbors.isNotEmpty) {
        for (int j = 0; j < neighbors.length; j++) {
          List<int> path = [i];
          int startingNeighborIndex = neighbors[j];
          List<List<int>> tmpAdjacencyList = List.from(leftoverAdjacencyList);
          tmpAdjacencyList[startingNeighborIndex] =
              tmpAdjacencyList[startingNeighborIndex].where((nodeIndex) => nodeIndex != i).toList();
          path.addAll(Graph.findShortestPath(tmpAdjacencyList, startingNeighborIndex, i));
          extraPaths.add(path);
        }
      }
    }

    List<List<int>> leftoverCycles = [];
    for (int i = 0; i < extraPaths.length; i++) {
      if (leftoverCycles
          .where((cycle) => Graph.doArraysContainSameElements(cycle, extraPaths[i]))
          .isEmpty) {
        leftoverCycles.add(extraPaths[i]);
      }
    }

    int longestCycleLength = -1;
    int longestCycleIndex = -1;
    for (int i = 0; i < leftoverCycles.length; i++) {
      if (leftoverCycles[i].length > longestCycleLength) {
        longestCycleIndex = i;
        longestCycleLength = leftoverCycles[i].length;
      }
    }

    if (longestCycleIndex != -1) {
      leftoverCycles.removeAt(longestCycleIndex);
    }
    uniqueCycles.addAll(leftoverCycles);

    return uniqueCycles;
  }

  static bool doArraysContainSameElements(List<int> array1, List<int> array2) {
    if (array1.length != array2.length) {
      return false;
    } else {
      for (int i = 0; i < array1.length; i++) {
        if (!array2.contains(array1[i])) {
          return false;
        }
      }
    }
    return true;
  }

  static List<int> findShortestPath(List<List<int>> adjacencyList, int source, int target) {
    if (source == target) {
      print("SOURCE AND TARGET ARE SAME");
      return [target];
    }
    List<int> visitQueue = [source];
    Map<int, bool> visitedStatusList = {source: true};
    Map<int, int> predecessorList = {};
    int nextInQueue = 0;

    while (nextInQueue < visitQueue.length) {
      int node = visitQueue[nextInQueue++];
      List<int> neighbors = adjacencyList[node];

      for (int i = 0; i < neighbors.length; i++) {
        int neighbor = neighbors[i];
        if (!visitedStatusList.containsKey(neighbor)) {
          visitedStatusList[neighbor] = true;
          if (neighbor == target) {
            // Check if the path is complete.
            List<int> path = [target]; // If so, backtrack through the path.
            while (node != source) {
              path.add(node);
              node = predecessorList[node]!;
            }
            path.add(source);
            path = path.reversed.toList();
            return path;
          }
          predecessorList[neighbor] = node;
          visitQueue.add(neighbor);
        }
      }
    }
    print('There is no path from $source to $target');
    return [];
  }
}

class Node {
  Point point;
  int? id;

  Node(this.point);

  bool equals(Node node) {
    return Point.equalsTwoPoints(point, node.point) && id == node.id;
  }
}

class Connection {
  Node node1;
  Node node2;

  Connection(this.node1, this.node2);

  bool equals(Connection connection) {
    return (node1.equals(connection.node1) && node2.equals(connection.node2)) ||
        (node2.equals(connection.node1) && node1.equals(connection.node2));
  }
}
