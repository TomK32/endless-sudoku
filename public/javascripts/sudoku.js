
Sudoku = function(data) {
  this.updateData(data);

  this.figures = []; // anything drawn that relates to this suduoku
  this.board = null;
}

Sudoku.prototype.updateData = function(data) {
  this.id = data.id;
  this.lat = data.lat;
  this.lng = data.lng;
  this.rows = data.rows;
}

Sudoku.prototype.selectNumber = function(element, event) {
  this.board.drawNumberSelector(event.offsetX, event.offsetY, element);
}

Sudoku.prototype.get = function() {
  $.get('/sudoku/' + this.id);
}

Sudoku.prototype.offSet = function(pos) {
  return ( this.board.scale(Math.floor((pos+2) / 3 - 1) * ( 0.3 / this.rows.length) * this.board.sudokuSize));
}
Sudoku.prototype.xPos = function(row) {
  return( this.board.scale(( (row / this.rows.length) + (6.6/9*this.lng)) * this.board.sudokuSize + this.offSet(row)));
}
Sudoku.prototype.yPos = function(column) {
  return(this.board.scale( (column / this.rows.length) + (6.6/9*this.lat)) * this.board.sudokuSize + this.offSet(column));
}

Sudoku.prototype.drawField = function(col,row) {
  return(this.board.paper.rect(this.xPos(col + 1) - this.board.fieldSize / 2,
              this.yPos(row + 1) - this.board.fieldSize / 2,
              this.board.scale(this.board.fieldSize), this.board.scale(this.board.fieldSize, 4)).
    attr({sudoku: this, data: {sudoku_id: this.id, col: col, row: row}, fill: '#FFF', 'fill-opacity': 0.8}));
}

Sudoku.prototype.addEmptyField = function(col, row) {
  this.figures.push(
    this.drawField(col, row).click(function(event){ this.attrs.sudoku.selectNumber(this, event); })
  );
}
Sudoku.prototype.addSolvedField = function(col, row, number) {
  this.figures.push(this.drawField(col, row).attr({'fill-opacity': 0.1}));
  this.figures.push(this.board.paper.text(this.xPos(col + 1), this.yPos(row+1), number).attr({'font-size': this.board.scale(12)}));
}
Sudoku.prototype.draw = function() {
  $(this.figures).map(function(i, e){ e.remove() });
  for(var row=0; row < this.rows.length; row++) {
    var numbers = this.rows[row].toString().split('');
    for(var col=0; col < numbers.length; col++) {
      if(numbers[col] == 0) {
        this.addEmptyField(col, row);
      } else {
        this.addSolvedField(col, row, numbers[col]);
      }
    }
  }
}
