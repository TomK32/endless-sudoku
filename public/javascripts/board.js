Board = function(data, selector) {
  this.id = data.id;
  this.name = data.name
  this.selector = selector;
  this.sudokus = [];
  this.paper = null;
  this.sudokuSize = 200;
  this.fields = 9;
  this.fieldSize = this.sudokuSize / this.fields;
  this.boardWidth = window.innerWidth;
  this.boardHeight = window.innerHeight - $('#' + this.selector).offset().top;
  this.numberSelector = [];
  this.statistics = [];
  $('#' + this.selector).data({board: this});
}

Board.getBoard = function(id) {
  return ($('#board_' + id));
}

Board.prototype.loadData = function() {
  var request = $.ajax({url: '', async: false, data: {format: 'json', id: this.id}});
  if(request.status == 200) {
    $('#error').hide();
    this.data = $.parseJSON(request.responseText);
    this.name = this.data.name
    this.populate(this.data.sudokus);
    this.draw();
  }
}
Board.prototype.populate = function(sudokus) {
  for(var i = 0; i < sudokus.length; i++) {
    var s = new Sudoku(sudokus[i]);
    s.board = this;
    this.sudokus.push(s);
  }
}

Board.prototype.createPaper = function() {
  this.paper = Raphael(this.selector, this.boardWidth, this.boardHeight);
  this.paper.rect(0,0, this.boardWidth, this.boardHeight, 0).attr({fill: "90-#93CCEA-#FADA5E:10-#FAFA8E", 'fill-opacity': 0.6});

  this.paper.customAttributes.data   = function (data)   { return data;   }
  this.paper.customAttributes.sudoku = function (sudoku) { return sudoku; }
  this.paper.customAttributes.board  = function (board) { return board; }

  this.statistics = this.paper.rect(this.boardWidth - 200, 20, 180, this.boardHeight - 40).
    attr({fill: "90-#73C2FB:15-#69AFD0:25"});
  this.paper.text(this.boardWidth - 110, 40, this.name).attr({fill: '#0F4D92', 'font-size': 20});
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
      attr({fill: '#000', 'fill-opacity': 0.3, board: this}).
      click(function(event) { this.attrs.board.removeNumberSelector(); }));

  this.numberSelector.push(this.paper.rect(x-5,y-5,this.sudokuSize/3+10, (this.sudokuSize/3)+10).attr({fill: '#FFF'}));
  for(var i=1; i <= this.fields; i++) {
    posX = x + (((i-1) % 3) * this.fieldSize);
    posY = y + (Math.floor((i-1) / 3) * this.fieldSize);
    this.numberSelector.push(this.paper.text(posX + this.fieldSize / 2, posY + this.fieldSize / 2, i));
    var data = $.extend(true, {}, element.attrs.data);
    data.number = i;
    this.numberSelector.push(
      this.paper.rect(posX, posY, this.fieldSize, this.fieldSize).
        attr({fill: '#fff', 'fill-opacity': 0.0, data: data, sudoku: element.attrs.sudoku}).
        click(function(event) {
          Board.postNumber(this, this.attrs.sudoku);
        })
    );
  }
}

Board.prototype.addSudoku = function(lat, lng) {
  var data = {lat: lat, lng: lng};
  $.ajax({url: '/boards/' + this.id + '/sudokus.json', type: 'post', async: false, data: data});
}

// Send to server and ask if it's correct
Board.postNumber = function(element, sudoku) {
  data = element.attrs.data;
  data._method = 'put';
  var url = '/boards/' + sudoku.board.id + '/sudokus/' + sudoku.id + '.json';
  var request = $.ajax({type: 'post', url: url, async: false, data: data});
  data = $.parseJSON(request.responseText);
  if(data.error) {
    element.attr({fill: '#FF0000', 'fill-opacity' : 0.5})
  } else {
    sudoku.updateData(data);
    sudoku.draw();
    sudoku.board.removeNumberSelector();
  }
}

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
  return ( Math.floor((pos+2) / 3 - 1) * ( 0.3 / this.rows.length) * this.board.sudokuSize);
}
Sudoku.prototype.xPos = function(row) {
  return( ( (row / this.rows.length) + (6.6/9*this.lng)) * this.board.sudokuSize + this.offSet(row))
}
Sudoku.prototype.yPos = function(column) {
  return(( (column / this.rows.length) + (6.6/9*this.lat)) * this.board.sudokuSize + this.offSet(column))
}

Sudoku.prototype.drawField = function(col,row) {
  return(this.board.paper.rect(this.xPos(col + 1) - this.board.fieldSize / 2,
              this.yPos(row + 1) - this.board.fieldSize / 2,
              this.board.fieldSize, this.board.fieldSize, 4).
    attr({sudoku: this, data: {sudoku_id: this.id, col: col, row: row}, fill: '#FFF', 'fill-opacity': 0.8}));
}

Sudoku.prototype.addEmptyField = function(col, row) {
  this.figures.push(
    this.drawField(col, row).click(function(event){ this.attrs.sudoku.selectNumber(this, event); })
  );
}
Sudoku.prototype.addSolvedField = function(col, row, number) {
  this.figures.push(this.drawField(col, row).attr({'fill-opacity': 0.1}));
  this.figures.push(this.board.paper.text(this.xPos(col + 1), this.yPos(row + 1), number));
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
