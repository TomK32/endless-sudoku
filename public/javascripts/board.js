Board = function(id, selector) {
  this.id = id;
  this.selector = selector;
  this.sudokus = [];
  this.paper = null;
  this.sudokuSize = 200;
  this.fields = 9;
  this.fieldSize = this.sudokuSize / this.fields;
  this.boardWidth = window.innerWidth;
  this.boardHeight = window.innerHeight - $('#' + this.selector).offset().top;
  this.numberSelector = [];
}

Board.prototype.populate = function(sudokus) {
  for(i = 0; i < sudokus.length; i++) {
    s = new Sudoku(sudokus[i]);
    s.board = this;
    this.sudokus.push(s);
  }
}

Board.prototype.createPaper = function() {
  this.paper = Raphael(this.selector, this.boardWidth, this.boardHeight);
  this.paper.rect(0,0, this.boardWidth, this.boardHeight, 5).attr({fill: "90-#df0:10-#ada-#0fa", 'fill-opacity': 0.6});

  this.paper.customAttributes.data   = function (data)   { return data;   }
  this.paper.customAttributes.sudoku = function (sudoku) { return sudoku; }
  this.paper.customAttributes.board  = function (board) { return board; }
}
Board.prototype.draw = function() {
  if (!this.paper) {
    this.createPaper();
  }
  $(this.sudokus).each(function(i, sudoku) {
    sudoku.draw();
  });
}
Board.prototype.removeNumberSelector = function() {
  this.numberSelector.map(function(e) { e.remove() });
}
Board.prototype.drawNumberSelector = function(x, y, element) {
  x = x - this.sudokuSize / 6;
  y = y - this.sudokuSize / 6;

  // first grey out the board
  this.numberSelector.push(
    this.paper.rect(0,0, this.paper.width, this.paper.height).
      attr({fill: '#000', 'fill-opacity': 0.2, board: this}).
      click(function(event) { this.attrs.board.removeNumberSelector(); }));

  this.numberSelector.push(this.paper.rect(x-5,y-5,this.sudokuSize/3+10, (this.sudokuSize/3)+10).attr({fill: '#FFF'}));
  for(i=1; i <= this.fields; i++) {
    posX = x + (((i-1) % 3) * this.fieldSize);
    posY = y + (Math.floor((i-1) / 3) * this.fieldSize);
    this.numberSelector.push(this.paper.text(posX + this.fieldSize / 2, posY + this.fieldSize / 2, i));
    this.numberSelector.push(
      this.paper.rect(posX, posY, this.fieldSize, this.fieldSize).
        attr({fill: '#fff', 'fill-opacity': 0.0, data: $.merge(element.attrs.data, {number: i})}).
        click(function(event) {
          Board.postNumber(this.attrs.data, i);
        })
    );
  }
}


// Send to server and ask if it's correct
Board.postNumber = function(data, number) {
  $.post('/sudokus/' + data.sudoku_id, $.merge(data, {number: number}));
}

Sudoku = function(data) {
  this.id = data.id;
  this.lat = data.lat;
  this.lng = data.lng;
  this.rows = data.rows;

  this.figures = []; // anything drawn that relates to this suduoku
  this.board = null;
}


Sudoku.prototype.selectNumber = function(element, event) {
  this.board.drawNumberSelector(event.offsetX, event.offsetY, element);
}

Sudoku.prototype.get = function() {
  $.get('/sudoku/' + this.id);
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

Sudoku.prototype.field = function() {

}
Sudoku.prototype.drawField = function(col,row) {
  return(this.board.paper.rect(this.xPos(col + 1) - this.board.fieldSize / 2,
              this.yPos(row + 1) - this.board.fieldSize / 2,
              this.board.fieldSize, this.board.fieldSize, 4).
    attr({sudoku: this, data: {sudoku_id: this.id, col: col, row: row}, fill: '#FFF', 'fill-opacity': 0.4}));
}

Sudoku.prototype.addEmptyField = function(col, row) {
  this.figures.push(
    this.drawField(col, row).click(function(event){ this.attrs.sudoku.selectNumber(this, event); })
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
