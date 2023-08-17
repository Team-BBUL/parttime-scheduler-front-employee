class Cell {
  final int row;
  final int col;
  bool isSelected;
  bool isSelectedColumn;
  Cell(this.row,this.col, {this.isSelected = false, this.isSelectedColumn = false});
}
