#require "lib/pikabu/version"
#questions: why dont we need to require pikabu?
#how can we close file after going into the pry?
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

  #first, run and listn for stdout
  #if stdout includes error, get line number
  #rerun, setting line number to line_num
  #else, say no errors detected

  

  def capture_stdout
  stdin, stdout, stderr = Open3.popen3("ruby #{@file_path}")
  error = stderr.readlines 
  stdin.close
  stdout.close
  stderr.close
    if error == []
        puts "\nYou clever chicken! Pikabu detected no errors in your script!" 
        puts "\n"
        puts "    O>     O>"
        puts "    |      |"
        puts ">OOOO  >OOOO"
        puts "  ^ ^    ^ ^"
        puts "      O> "
        puts "      |"
        puts "  >OOOO"
        puts "    ^ ^"
        return
     else

        if /.rb:\d\d\d/=~ error.first
            num = (/.rb:\d\d\d/=~ error.first)+4
            @line_num = error.first[num..num+2].to_i
        elsif /.rb:\d\d/ =~ error.first
            num = (/.rb:\d\d/=~ error.first)+4
            @line_num = error.first[num..num+1].to_i

        elsif /.rb:\d/=~ error.first
            num = (/.rb:\d/=~ error.first)+4
            @line_num = error.first[num].to_i
        else 
          puts "?!?"
        end
        puts "\nPikabu detected an error on line #{@line_num} of #{@file_path}"
    end
  peek  
  end


  def head 
    line = 0
    @file.each do |l|
      if line < (@line_num-1)
        @f.write(l)
        line+=1
      end 
    end 
  end 

  def tail
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
    head
    @f << "binding.pry\n"
    tail
    @f.rewind
    load @f 
    File.delete("#{@pwd}/temp")
  end

end
#Pikabu.new('user_script.rb')
#binding.pry

