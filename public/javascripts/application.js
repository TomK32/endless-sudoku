// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
$(document).ready(function(){
  $('#error').ajaxError(function(event) {
    $(this).html('An error occurreced or your internet connection is cut. <a href="#" onclick="$(this).parent().hide(); return false;">x</a>').show();
  });
  
  $(document).ajaxComplete(function(event, XMLHttpRequest, ajaxOptions) {
    if(ajaxOptions.type == "POST") {
      // no user but normally we should have one after the POST
      if(!user) {
        user = new User({id: 0});
      }
      user.updateData();
    }
  });
});
