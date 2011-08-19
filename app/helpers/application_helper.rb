module ApplicationHelper
  def h1_title(title)
    @title = title
    content_tag(:h1, title)
  end
end
