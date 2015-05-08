#require "lib/pikabu/version"
require "tempfile"
require "fileutils"
require "pry"
require "open3"
class Pikabu

  def initialize(file_path, line_num)
    @file_path = file_path
    @line_num = line_num
    @file = File.open(@file_path)
    @length = File.readlines(@file_path).size
    @t = Tempfile.new("temp")
    pwd = FileUtils.pwd()
     binding.pry
    FileUtils.mv(@t, pwd)
    capture_stdout 
  end 

  #first, run and listn for stdout
  #if stdout includes error, get line number
  #rerun, setting line number to line_num
  #else, say no errors detected
  
  #why can't i move temp file to new directory
  #how do i add executables to bin
  #why can it not find oikabu/version
  

  def capture_stdout
   
  #   output = IO.popen(@file_path)
  #   #why is permission denied?
  #   output.readlines

  #   stdin, stdout, stderr = Open3.popen3(@file_path)
  end




  def loads
    load @file_path
    #$stdout = 
    puts "nothing weird here"
  end 


  def head 
    line = 0
    @file.each do |l|
      if line < @line_num
        @t.write(l)
        line+=1
      end 
    end 
  end 

  def tail
  line = 0
  file = File.open(@file_path)
  #why does this not work if i use @file instead of reopening file?
  file.each do |l|
      if line >= @line_num
        @t << l
      end 
      line+=1
    end 
  end 


  def peek
    @t.write ("require 'pry'\n")
    head
    @t << "\nbinding.pry\n"
    tail
    @t.rewind
    load @t
    @t.close
  end

end
#binding.pry

