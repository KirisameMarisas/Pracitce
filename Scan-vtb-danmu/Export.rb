
require "csv"

module Export
  @output_file_name = "test.csv"
  @dir_name = "./Danmu"
  @array_csv = []

  def output_file
    return @output_file_name
  end

  def Scan(path)
    @file_name = path

    #get the date
    @date = File.basename(@file_name, ".txt")
    #open file
    fp = File.open(@file_name, "r")

    fp.each do |each_line|
      #delete the line break and space 
      each_line.chomp!
      each_line.rstrip!

      #find the position of the last space
      pos = each_line.rindex(" ")
      #get the information 
      temp_string = [each_line[0,pos],each_line[pos+1,each_line.length]]
      #insert a nil to fill the block in csv file 
      temp_string.insert(1,nil)

      #push the date information
      temp_string.push(@date)

      #change the data structure from array to csv line 
      @array_csv.push(Marshal.load(Marshal.dump(temp_string)))
    end
  end

  #tracerse the file (copy from 'Scan.rb')
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

      Scan(path)

    end
  end

  #export to csv file 
  
  def output
    CSV.open("test.csv", "wb") do |csv|
      csv << ["name","type","value","date"]
      @array_csv.each do |element|
        csv << element
        puts element.inspect
      end
    end
  end

end

include Export

Export.traverse("./Danmu")
Export.output
