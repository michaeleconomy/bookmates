class EasyFormBuilder < ActionView::Helpers::FormBuilder
  include ActionView::Helpers::TagHelper
  
  def text_field(attribute, options = {})
    if options.is_a?(Hash)
      extra_stuff = options.delete :extra_stuff
    end
    content_tag(:div, label(attribute) + super(attribute, options || {}) + extra_stuff.to_s)
  end
  
  
  def text_area(attribute, options = {})
    if options.is_a?(Hash)
      extra_stuff = options.delete :extra_stuff
    end
    content_tag(:div, label(attribute) + super(attribute, options || {}) + extra_stuff.to_s)
  end
  
  def checkbox(attribute, options = {})
    if options.is_a?(Hash)
      extra_stuff = options.delete :extra_stuff
    end
    content_tag(:div, label(attribute) + super(attribute, options || {}) + extra_stuff.to_s)
  end
  
  def select(attribute, choices, options = {})
    if options.is_a?(Hash)
      extra_stuff = options.delete :extra_stuff
    end
    content_tag(:div, label(attribute) + super(attribute, choices, options || {}) + extra_stuff.to_s)
  end

end