
module ScanDanmu
  @data_hash = {}
  @file_name = ""
  #generate the 'date.txt' file 
  #@date_hash = {}

  def file_list
    fp = File.open("date.txt", "r")
    fp.each do |each_line|
      #get date
      @file_name = each_line.chomp

      #scan all file 
      traverse("./")
      #output the txt
      output(@data_hash, "./Danmu/" + "#{@file_name}")

      @data_hash.clear
    end
  end


  def traverse(path)
    if (File.directory?(path))
      dir = Dir.open(path)
      while name = dir.read
        next if name == "."
        next if name == ".."
        traverse(path + "/" + name)
      end
      dir.close
    else
      file_name = File.basename(path)
      #temp = File.extname(@file_name)

      if file_name == @file_name

        #generate 'date.txt'
        #if (judge(@file_name[0]))

        #hash_add(@date_hash, @file_name)
        #end

        process_file(path)
      end
    end
  end

  #add hash element 
  def hash_add(hash, data)
    if hash.key?(data)
      hash[data] += 1
    else
      hash[data] = 1
    end
  end

  #judge a string is a number 
  def judge(element)
    begin
      Float(element)
      return true
    rescue => exception
      return false
    end
  end

  #the stand danmu format is "timestamp:userid:content"
  def process_file(file)
    fp = File.open(file)

    fp.each do |each_line|
      initial = each_line[0]
      if (!judge(initial))
        next
      end

      #get the first position of ':'
      pos = each_line.index(":")

      #ignore the wrong format
      if pos == nil
        next
      end

      #get the remation part of data string
      temp = each_line[pos + 1, each_line.length]
      pos = temp.index(":")
      #get the danmu information
      danmu = temp[pos + 1, temp.length]
      #delete line break 
      danmu.chomp!
      
      hash_add(@data_hash, danmu)
    end
  end

  #output data information
  def output(hash, path = nil)
    #hash sort (descending)
    hash = hash.sort { |a, b| b[1] <=> a[1] }
    #only get the top 10 items
    _count = 1
    if (path == nil)
      hash.each do |each_key, each_value|
        puts "#{each_key} #{each_value}"
      end
    else
      fp = File.open(path, "w")
      hash.each do |each_key, each_value|
        fp.write("#{each_key} #{each_value} \n")
        _count += 1
        return if _count >= 10
      end
    end
  end

  #generte 'date.txt'
  def _output(hash)
    puts hash.inspect
    fp = File.open("date.txt", "w")
    hash = hash.sort_by { |key, value| key }
    hash.each do |each_key, each_value|
      fp.write(each_key + "\n")
    end
  end
end

include ScanDanmu
SD = ScanDanmu

SD.file_list

#generate 'date.txt'

#SD.traverse("./")
#SD._output(SD.date_hash)

