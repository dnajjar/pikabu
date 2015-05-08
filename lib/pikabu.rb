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
    @t = Tempfile.new("temp")
    pwd = FileUtils.pwd()
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
        puts "PIKABU SEES ALL THE ERRORS"
        if /\d\d\d/=~ error.first
            num = (/\d\d\d/=~ error.first)
            @line_num = error.first[num..num+2].to_i
        elsif /\d\d/ =~ error.first
            num = (/\d\d/=~ error.first)
            @line_num = error.first[num..num+1].to_i

        elsif /\d/=~ error.first
            num = (/\d/=~ error.first)
            @line_num = error.first[num].to_i
        else 
          puts "oops what's going on"
        end
        #ADD SOPHISTICATED EMOJIS
    end
    puts "PIKABU SEES YOUR ERROR ON LINE #{@line_num}"
    peek 
  end


  def head 
    line = 0
    @file.each do |l|
      if line < (@line_num-3)
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
      if line >= (@line_num-3)
        @t << l
      end 
      line+=1
    end 
  end 


  def peek
    #binding.pry
    @t.write ("require 'pry'\n")
    head
    @t << "  binding.pry\n"
    tail
    @t.rewind
    load @t
    @t.close
  end

end
Pikabu.new('user_script.rb')
#binding.pry

