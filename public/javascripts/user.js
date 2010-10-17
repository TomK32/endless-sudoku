User = function(data) {
  this.paper = null;
  this.boxWidth = 120;
  this.boxHeight = 60;
  this.scoreField = null;
  this.nameField = null;
  this.setData(data);
}

User.prototype.updateData = function() {
  request = $.ajax({url: '/users/' + this.id, async: false});
  this.setData($.parseJSON(request.data));
}
User.prototype.setData = function(data) {
  this.id = data.id
  this.name = data.name;
  this.score = data.score;
  this.draw();
}

User.prototype.draw = function() {
  if(this.paper) this.paper.remove();
  this.paper = Raphael(10, window.innerHeight - 70, this.boxWidth, this.boxHeight);
  this.paper.rect(0,0, this.boxWidth, this.boxHeight, 0).attr({fill: "#5EDAFA", 'fill-opacity': 0.6});
  if(this.name == null) {
    this.name = prompt("What's your name?");
    var email = prompt("And your email address?");
    $.post('/users/' + this.id + '.json', {format: 'json', user: {name: this.name, email: email, '_method': 'put'}});
  }
  this.nameField = this.paper.text(this.boxWidth / 2, 15, this.name).attr({'font-size': 15});
  this.scoreField = this.paper.text(this.boxWidth / 2, 40, "score: " + this.score).attr({'font-size': 15});;
}