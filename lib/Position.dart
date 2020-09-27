class Position{
  int row;
  int column;

  Position(this.column, this.row);

  bool isNeighbor(Position other) {
    return directlyAbove(other) || directlyBelow(other) || directlyLeft(other) || directlyRight(other) || inDiagonal(other);
  }

  bool directlyAbove(Position other) {
    return column == other.column && row == other.row - 1;
  }

  bool directlyBelow(Position other) {
    return column == other.column && row == other.row + 1;
  }

  bool directlyLeft(Position other) {
    return row == other.row && column == other.column - 1;
  }

  bool directlyRight(Position other) {
    return row == other.row && column == other.column + 1;
  }

  bool inDiagonal(Position other) {
    if (row == other.row + 1 || row == other.row - 1) {
      return column == other.column + 1 || column == other.column - 1;
    }
    return false;
  }
}