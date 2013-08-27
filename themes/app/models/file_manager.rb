class FileManager
  
  def initialize(root, parent=nil)
    @root = root
    @parent = parent
  end

  def dirs(path=".")
    path = "" if path.nil?
    @path = File.join(File.expand_path(@root), path)
    if File.exists?(@path)
      Dir.entries(@path).sort {|a,b| a <=> b}.inject([]) do |ary, folder|
          ary << {
              :attr => { :fullpath => File.join(@parent, folder), :rel => 'folder'},
              :data => folder,
              :state => Dir[Rails.root.join("themes/#{Refinery::Themes::Theme.current_theme_key}/#{@parent}/#{folder}/*")].empty? ? 'leaf' : 'closed'
          } if File.directory?(File.join(@path, folder)) && folder[0,1] != "."
        ary
      end
    end
  end

  def files(path=".")
    path = "" if path.nil?
    @path = File.join(File.expand_path(@root), path)
    if File.exists?(@path)
      Dir.entries(@path).sort {|a,b| a <=> b}.inject([]) do |ary, file|
        ary << {:attr => {:fullpath => "#{@parent}/#{file}", :rel => 'default'}, :data => file, :state => 'leaf'} if File.file?(File.join(@path, file))
        ary
      end
    end
  end


  def self.create_file(parent_dir, filename)
    content_type = Editable.mime_for filename
    target_name = self.slugify(filename)

    if filename_ext = File.extname(filename)
      target_name = self.slugify(filename[0..-(filename_ext.length+1)]) + filename_ext
    end

    return {:notice => "Files of this type (#{filename_ext}) are not allowed!"} unless self.allowed_content_type?(filename_ext)

    target = File.join(Rails.root, 'themes', Refinery::Themes::Theme.current_theme_key, parent_dir, target_name)

    begin
      File.open(target, 'w+') do |file|
        file.write('')
      end
    rescue SystemCallError => boom
      return {:notice => "Error: #{boom}"}
    end

    if File.exist?(target)
      result = {:status => 1,
                :fullpath => File.join(parent_dir, target_name),
                :notice => ('File "%s" was successfully added' % File.basename(target_name)),
                :node_name => target_name
      }
    else
      result = {:notice => 'File "%s" could not be uploaded' % File.basename(target_name)}
    end
    result
  end

  def self.save_file(file_name, content)
    file = File.join(Rails.root, "themes", Refinery::Themes::Theme.current_theme_key, file_name)

    begin
      File.open(file, 'w+b') do |f|
        f.write(content)
      end
    rescue SystemCallError => boom
      return {:notice => "Error: #{boom}"}, :layout => false
    end

    File.read(file)
  end


  # remove dir
  def self.remove_dir(fullpath)
    begin
      Dir.rmdir(File.join(Rails.root, 'themes', Refinery::Themes::Theme.current_theme_key, fullpath))
      return {:status => 1, :notice => ('Directory "%s" was successfully removed' % fullpath)}
    rescue SystemCallError => boom
      return {:notice => "Error: #{boom}"}
    end
  end

  # remove file
  def self.remove_file(fullpath)
    begin
      File.delete(File.join(Rails.root, 'themes', Refinery::Themes::Theme.current_theme_key, fullpath))
      notice = 'File "%s" was successfully removed' % fullpath
      return {:status => 1, :notice => notice}
    rescue SystemCallError => boom
      return {:notice => "Error: #{boom}"}
    end
  end


  # rename dir
  def self.rename_dir(fullpath, new_name)
    target_name = slugify(new_name)
    segments = fullpath.split("/")
    segments.pop
    dir_path = segments.join('/')

    begin
      File.rename(File.join(Rails.root, 'themes', Refinery::Themes::Theme.current_theme_key, fullpath),
                  File.join(Rails.root, 'themes', Refinery::Themes::Theme.current_theme_key, dir_path, target_name))
    rescue SystemCallError => boom
      return {:notice => "Error: #{boom}"}
    end

    {
        :status => 1,
        :fullpath => File.join(dir_path, target_name),
        :notice => ('Directory "%s" was successfully renamed' % target_name),
        :node_name => target_name
    }

  end


  # rename file
  def self.rename_file(fullpath, new_name)
    content_type = Editable.mime_for new_name
    target_name = self.slugify(new_name)
    if filename_ext = File.extname(new_name)
      target_name = self.slugify(new_name[0..-(filename_ext.length+1)]) + filename_ext
    end

    unless FileManager.allowed_content_type?(filename_ext)
      return {:notice => "Files of this type (#{filename_ext}) are not allowed!"}
    end

    dir_path = File.dirname(fullpath)

    begin
      File.rename(File.join(Rails.root, 'themes', Refinery::Themes::Theme.current_theme_key, fullpath),
                  File.join(Rails.root, 'themes',Refinery::Themes::Theme.current_theme_key, dir_path, target_name))
    rescue SystemCallError => boom
      return {:notice => "Error: #{boom}"}
    end

    {
        :status => 1,
        :fullpath => File.join(dir_path, target_name),
        :notice => ('File "%s" was successfully renamed' % File.basename(target_name)),
        :node_name => target_name
    }

  end

  # create dir
  def self.create_dir(parent_dir, dir_name)
    slugged_name = slugify(dir_name)
    path = File.join(Rails.root, 'themes', Refinery::Themes::Theme.current_theme_key, parent_dir)
    create_path = File.join(path, slugged_name)

    if self.secured_path?(path) && !File.exist?(create_path) && FileUtils.mkdir(create_path)
      result = {:status => 1,
                :fullpath => File.join(parent_dir, slugged_name),
                :notice => ('Directory "%s" was successfully created' % slugged_name),
                :node_name => slugged_name
      }
    else
      result = {:notice => 'Directory "%s" could not be created' % slugged_name}
    end

    result

  end

  def self.unzip_file (file)
    require 'zip/zip'

    Zip::ZipFile.open(file) { |zip_file|
      zip_file.each { |f|
        f_path=File.join(Rails.root.join('themes'), f.name)
        FileUtils.mkdir_p(File.dirname(f_path))
        zip_file.extract(f, f_path) unless File.exist?(f_path)
      }
    }
  end

  def self.allowed_content_type?(type)
    return true unless Editable.mime_for(".#{type}").eql?('unknown_type')
    return false if Editable.mime_for(".#{type}").eql?('unknown_type')
  end


  private

  def self.secured_path?(file_path)
    File.exist?(file_path) && !File.dirname(file_path).index(Rails.root.join('themes').to_s).nil?
  end

  def self.slugify(value)
    value.mb_chars.normalize(:kd).gsub(/[^\x00-\x7F]/n, '').to_s.downcase.gsub(/[']+/, '').gsub(/\W+/, ' ').strip.gsub(' ', '-')
  end

end
