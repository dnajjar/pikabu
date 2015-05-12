#questions: why dont we need to require pikabu?
#how can we close file after going into the pry?

require_relative "../lib/pikabu/version.rb"
require "tempfile"
require "fileutils"
require "pry"
require "open3"

class Pikabu

  def initialize(file_path)
    @file_path = file_path
    @file = File.open(@file_path)
    @length = File.readlines(@file_path).size
    @pwd = FileUtils.pwd()
    @f = File.new("#{@pwd}/temp.rb", "w")
    capture_stdout
  end 

  def capture_stdout
    stdin, stdout, stderr = Open3.popen3("ruby #{@file_path}")
    @error = stderr.readlines 
      if @error == []
          puts "\nYou clever chicken! Pikabu detected no errors in your script!" 
          puts "\n"
          puts "      O>    "
          puts "      |     "
          puts "  >OOOO     " 
          puts "    ^ ^     "
          return
       else
            m =  /.rb:(\d+)/.match(@error.first)
            @line_num = m[1].to_i
           puts "\nPikabu detected an error on line #{@line_num} of #{@file_path}"
      end
    peek  
  end

  def write_head 
    line = 0
    @file.each do |l|
      if line < (@line_num-1)
        @f.write(l)
        line+=1
      end 
    end 
  end 

  def write_tail
  line = 0
  file = File.open(@file_path)
  #why does this not work if i use @file instead of reopening file?
  file.each do |l|
      if line >= (@line_num-1)
        @f << l
      end 
      line+=1
    end 
  end 


  def peek
    @f.write ("require 'pry'\n")
    write_head
    @f << "binding.pry\n"
    write_tail
    @f.rewind
    load @f 
    File.delete("#{@pwd}/temp")
  end

  def find_error_line(num, space)
    num +=4
    @line_num = @error.first[num..num+space].to_i
  end 

end


