#require "lib/pikabu/version"
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
    @f = File.new("#{@pwd}/temp", "w")
    capture_stdout

  end 

  #first, run and listn for stdout
  #if stdout includes error, get line number
  #rerun, setting line number to line_num
  #else, say no errors detected
  #why can't i move temp file to new directory
  

  def capture_stdout
  #binding.pry
  stdin, stdout, stderr = Open3.popen3("ruby #{@file_path}")
  error = stderr.readlines 
  stdin.close
  stdout.close
  stderr.close
    if error == []
        puts "PIKABU SEES NO ERRORS IN YOUR SCRIPT" 
        puts "    O> "
        puts "    |"
        puts " OOOO"
        puts "  ^ ^"
        puts "      O> "
        puts "      |"
        puts "   OOOO"
        puts "    ^ ^"
     else
      #binding.pry
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
      if line < (@line_num-3)
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
      if line >= (@line_num-3)
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
    puts "hello"
  end

end
#Pikabu.new('user_script.rb')
#binding.pry

