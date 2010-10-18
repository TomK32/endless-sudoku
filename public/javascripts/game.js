Game = function() {
  
}

Game.sendRequest = function(ajaxParameters, objectToReturn) {
  var request = $.ajax(ajaxParameters);
  data = $.parseJSON(request.responseText);
  if(objectToReturn) {
    if(data.user)
      user.setData(data.user);
    if(data[objectToReturn])
      return data[objectToReturn];
  }
  return data;
}