Board = function(data, selector) {
  this.id = data.id;
  this.name = data.name
  this.selector = selector;
  this.sudokus = [];
  this.paper = null;
  this.defaultAttrs = {scale: 1, board: this};
  this.sudokuSize = 200;
  this.fields = 9;
  this.fieldSize = this.sudokuSize / this.fields;
  this.boardWidth = $('#' + this.selector).width();
  this.boardHeight = $(window).height() - $('#' + this.selector).offset().top;
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

  var y = 60;
  this.statistics = this.paper.rect(this.boardWidth - 200, y, 180, 200).
    attr({fill: "90-#73C2FB:15-#69AFD0:25"});
  this.paper.text(this.boardWidth - 110, y+20, this.name).attr({fill: '#0F4D92', 'font-size': 20});
}
Board.prototype.draw = function() {
  if (!this.paper) {
    this.createPaper();
  }
  $(this.sudokus).each(function(i, sudoku) {
    sudoku.draw();
  });
  this.drawControls();
}
Board.prototype.attrs = function(other) {
  return $.extend(true, other, this.defaultAttrs);
}
Board.prototype.scale = function(value) {
  if(this.defaultAttrs.scale)
    return value * this.defaultAttrs.scale;
  return value;
}
Board.prototype.scaleBoard = function(delta) {
  this.defaultAttrs.scale += delta;
  this.sudokus.map(function(s){ s.draw(); });
}
Board.prototype.drawControls = function() {
  var x = this.boardWidth - 50;
  var y = 20;
  var font = {'font-size': 20};
  this.paper.rect(x-150, y - 5, 180, 30).attr({fill: '#FFFFFF'});
  this.paper.text(x + 10, y + 10, '+').attr(font);
  this.paper.rect(x, y, 20, 20).attr(this.attrs({fill: '#FFFFFF', 'fill-opacity': 0.0})).
    click(function() { this.attrs.board.scaleBoard(0.1) });
  x -= 40;
  this.paper.text(x + 10, y + 10, '-').attr(font);
  this.paper.rect(x, y, 20, 20).attr(this.attrs({fill: '#FFFFFF', 'fill-opacity': 0.0})).
    click(function() { this.attrs.board.scaleBoard(-0.1) });
  x -= 70;
  this.paper.text(x+10, y+10, 'Scale').attr(font);
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
  data = Game.sendRequest({type: 'post', url: url, async: false, data: data}, 'sudoku');
  if(data.error) {
    element.attr({fill: '#FF0000', 'fill-opacity' : 0.5})
  } else {
    sudoku.updateData(data);
    sudoku.draw();
    sudoku.board.removeNumberSelector();
  }
}
