require 'aws-sdk'

class S3

  def self.reconfig(bucket_name = ENV['AWS_S3_BUCKET'])
    @instance = S3.new
  end

  def self.get
    @instance ||= S3.new
  end

  def initialize(bucket_name = ENV['AWS_S3_BUCKET'])
    Aws.config.update(
      credentials: Aws::Credentials.new(ENV['AWS_ACCESS_KEY_ID'], ENV['AWS_ACCESS_KEY_SECRET']),
      region: ENV['AWS_REGION'],
    )

    @bucket = resource.bucket(bucket_name)
  end

  def list_folders(prefix)
    resp = client.list_objects(bucket: ENV['AWS_S3_BUCKET'], prefix: prefix, delimiter: '/')
    resp.common_prefixes.to_a.collect(&:prefix)
  end

  def list_files(prefix)
    resp = client.list_objects(bucket: ENV['AWS_S3_BUCKET'], prefix: prefix, delimiter: '/')
    resp.contents.collect(&:key)
  end

  def store(name, src)
    obj = @bucket.object(name)
    obj.upload_file(src, {content_encoding: "UTF-8"})
  end

  def get_file(file_name, dest)
    # puts "S3 Downloading #{file_name}"
    if exists?(file_name)
      ::File.open(dest, 'wb') do |file|
        @bucket.object(file_name).get do |chunk|
          file.write(chunk)
        end
      end
    end
  end

  def store_folder(dir_name, src_dir)
    # puts "Uploading : #{dir_name}, #{src_dir}"
    Dir.foreach(src_dir) do |file_name|
      if file_name[0] == '.'
        next
      elsif ::File.file?("#{src_dir}/#{file_name}")
        store("#{dir_name}/#{file_name}", "#{src_dir}/#{file_name}")
      else    #directory/folder
        store_folder("#{dir_name}/#{file_name}","#{src_dir}/#{file_name}")
      end
    end
  end

  def exists?(name)
    @bucket.objects(prefix: name).first ? true : false
  end

  def each_file(dir_name, recursive: false)
    return to_enum(__callee__, dir_name, recursive: recursive) unless block_given?

    if exists?(dir_name)
      @bucket.objects(prefix: dir_name).map(&:key).each do |file_path|
        if is_folder?(file_path) || file_path == dir_name || (!recursive && is_file_in_folder?(file_path, dir_name))
          next
        end
        file_path.slice!(dir_name + '/')
        yield file_path
      end
    else
      raise FileStore::FileNotFound.new("Folder #{dir_name} was not found.")
    end
  end

  def each_line(name)
    return to_enum(__callee__, name) unless block_given?

    if exists?(name)
      buffer = ''
      @bucket.object(name).get do |chunk|
        buffer << chunk.encode('UTF-8', :invalid => :replace, :undef => :replace, :replace => '')
        buffer.gsub!(/\r\n?/, "\n")
        lines = buffer.lines
        if lines[-1][-1] == "\n"
          buffer.clear
        else
          buffer = lines.pop
        end

        lines.each { |line| yield line.chomp }
      end
      yield "#{buffer}\n" unless buffer.blank?
    else
      raise FileStore::FileNotFound.new("File #{name} was not found.")
    end
  end

  def delete(name)
    @bucket.object(name).delete
  end

  def delete_folder(folder_name)
    @bucket.objects(prefix: folder_name).delete
  end

  def path(name)
    "s3://#{@bucket.name}/#{name}"
  end

  private

  def client
    @client ||= Aws::S3::Client.new(region: ENV['AWS_REGION'])
  end

  def is_folder?(file_path)
    file_path[-1] == '/'
  end

  def is_file_in_folder?(file_path, dir_name)
    (file_path.count('/') > (dir_name.count('/')+1)) ? true : false
  end

  def resource
    @resource ||= Aws::S3::Resource.new(region: ENV['AWS_REGION'])
  end
end
