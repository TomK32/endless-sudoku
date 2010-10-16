Board = function() {
  this.sudokus = [];
  this.paper = null;
  this.sudokuSize = 200;
  this.fieldSize = this.sudokuSize / 9;
}

Board.prototype.populate = function(sudokus) {
  for(i = 0; i < sudokus.length; i++) {
    s = new Sudoku('1', 0, 0);
    s.rows = sudokus[i].rows;
    s.lat = sudokus[i].lat;
    s.lng = sudokus[i].lng;
    s.board = this;
    this.sudokus.push(s);
  }
}

Board.prototype.createPaper = function() {
  this.paper = Raphael(0,0, window.innerWidth, window.innerHeight);
  this.paper.rect(0,0, window.innerWidth, window.innerHeight, 5).attr({fill: "90-#df0:10-#ada-#0fa", 'fill-opacity': 0.6});
  
  this.paper.customAttributes.data = function (data) {
      return data;
  }
}
Board.prototype.draw = function() {
  if (!this.paper) {
    this.createPaper();
  }
  $(this.sudokus).each(function(i, sudoku) {
    sudoku.draw();
  });
}

Sudoku = function(id, lat, lng) {
  this._id = id;
  this.figures = []; // anything drawn that relates to this suduoku
  this.rows = [];
  this.lat = lat;
  this.lng = lng;
  this.board = null;
}


Sudoku.prototype.get = function() {
  $.get('/sudoku/' + this._id);
}

Sudoku.prototype.offSet = function(pos) {
  return ( Math.floor((pos+2) / 3 - 1) * ( 0.3 / this.rows.length) * this.board.sudokuSize);
}
Sudoku.prototype.xPos = function(row) {
  return( ( (row / this.rows.length) + (6.6/9*this.lng)) * this.board.sudokuSize + this.offSet(row))
}
Sudoku.prototype.yPos = function(column) {
  return(( (column / this.rows.length) + (6.6/9*this.lat)) * this.board.sudokuSize + this.offSet(column))
}

// Send to server and ask if it's correct
Sudoku.postNumber = function(data, number) {
  console.log($.merge(data, {number: number}));
}

Sudoku.prototype.field = function() {
  
}
Sudoku.prototype.drawField = function(col,row) {
  return(this.board.paper.rect(this.xPos(col + 1) - this.board.fieldSize / 2,
              this.yPos(row + 1) - this.board.fieldSize / 2,
              this.board.fieldSize, this.board.fieldSize, 4).
    attr({data: {sudoku_id: this._id, col: col, row: row}, fill: '#FFF', 'fill-opacity': 0.4}));
}

Sudoku.prototype.addEmptyField = function(col, row) {
  this.figures.push(
    this.drawField(col, row).
    click(function(event){ Sudoku.postNumber(this.attrs.data, prompt('What number?')); })
  );
}
Sudoku.prototype.addSolvedField = function(col, row) {
  this.figures.push(this.drawField(col, row).attr({'fill-opacity': 0.1}));
  this.figures.push(this.board.paper.text(this.xPos(col + 1), this.yPos(row + 1), numbers[col]));
}
Sudoku.prototype.draw = function() {
  $(this.figures).map(function(i, e){ e.remove() });
  for(row=0; row < this.rows.length; row++) {
    numbers = this.rows[row].toString().split('');
    for(col=0; col < numbers.length; col++) {
      if(numbers[col] == 0) {
        this.addEmptyField(col, row);
      } else {
        this.addSolvedField(col, row);
      }
    }
  }
}
