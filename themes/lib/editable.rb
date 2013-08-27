class Editable
  def self.mime_for(name)
    case name.to_s
      when /\.(png|gif|jpg|jpeg)\Z/
        "image"
      when /\.css\Z/
        "text/css"
      when /\.js\Z/
        "text/javascript"
      when /\.xml\Z/
        "application/xml"
      when /\.yml\Z/
        "text/x-yaml"
      when /\.json\Z/
        "application/json"
      when /\.txt\Z/
        "text/plain"
      when /\.liquid\Z/
        "liquid"
      when /\.(html|htm|xhtml)\Z/
        "text/html"
      else
        "unknown_type"
    end
  end
end
