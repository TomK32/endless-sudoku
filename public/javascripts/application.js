// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
$(document).ready(function(){
  b = new Board();
  b.populate([{lat: 0, lng: 0, rows: ["023456789", "234560091", "345678023", "406789123", "567891034", "678912345", "789123456", "891234567", "912300678"]}])
  b.draw();
})
