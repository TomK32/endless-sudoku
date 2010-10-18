module ApplicationHelper
  def javascript_ready_tag(code)
    javascript_tag("$(document).ready(function(){ %s });" % code)
  end
end
