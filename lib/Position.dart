class Position{
  int row;
  int column;

  Position(this.column, this.row);

  bool isNeighbor(Position other) {
    return directlyAbove(other) || directlyBelow(other) || directlyLeft(other) || directlyRight(other) || inDiagonal(other);
  }

  bool directlyAbove(Position other) {
    return column == other.column && row - 1 == other.row;
  }

  bool directlyBelow(Position other) {
    return column == other.column && row + 1 == other.row;
  }

  bool directlyLeft(Position other) {
    return row == other.row && column - 1 == other.column;
  }

  bool directlyRight(Position other) {
    return row == other.row && column + 1 == other.column;
  }

  bool inDiagonal(Position other) {
    if (row + 1 == other.row || row - 1 == other.row) {
      return column + 1 == other.column || column - 1 == other.column;
    }
    return false;
  }

  @override
  bool operator ==(Object other) => other is Position && row == other.row && column == other.column;

  @override
  int get hashCode => toString().hashCode;

  String toString() {
    return "($column, $row)";
  }
}