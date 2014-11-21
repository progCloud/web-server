module ApplicationHelper

  # Mapping from devise flast type to corresponding bootstrap class
  def bootstrap_class_for(flash_type)
    if flash_type == "success"
      return "alert-success"            # Green
    elsif flash_type == "error"
      return "alert-danger"             # Red
    elsif flash_type == "alert"
      return "alert-warning"            # Yellow
    elsif flash_type == "notice"
      return "alert-info"               # Blue
    else
      return flash_type.to_s
    end
  end

  def get_icon(content_type)
    if content_type.include? "image"
      return 'fa-file-image-o'
    elsif content_type.include? "pdf"
      return 'fa-file-pdf-o'
    elsif content_type.include? "zip"
      return 'fa-file-zip-o'
    elsif content_type.include? "video"
      return 'fa-file-video-o'
    elsif content_type.include? "audio"
      return 'fa-file-audio-o'
    elsif content_type.include? "powerpoint" or content_type.include? "presentation"
      return 'fa-file-powerpoint-o'
    elsif content_type.include? "word"
      return 'fa-file-word-o'
    elsif content_type.include? "excel" or content_type.include? "spreadsheetml"
      return 'fa-file-excel-o'
    elsif content_type.include? "text"
      return 'fa-file-text-o'
    else
      return 'fa-file-o'
    end
  end

end
