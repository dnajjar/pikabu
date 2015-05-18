require_relative "../lib/pikabu/version.rb"
require "fileutils"
require "pry"
require "open3"

class Pikabu

  def initialize(file_path, line_num)
    @file_path = file_path
    @line_num = line_num
    check_file_path
  end 

  def check_file_path
    begin
      load_paths
      check_line_num
    rescue LoadError, Errno::ENOENT => e
      print_help
    end
  end 

  def check_line_num
    if @line_num == nil
      capture_stdout
    elsif (@line_num.to_i>@length) || (@line_num.to_i<0) || (@line_num.to_i.to_s!=@line_num)
      puts "Please try again with a line number between 0 and #{@length}"
    else 
      @line_num = @line_num.to_i+1
      peek
    end 
  end

  def load_paths
    @file = File.open(@file_path)
    @length = File.readlines(@file_path).size
    @pwd = FileUtils.pwd()
    new_file
  end 

  def new_file
    path_array = @file_path.split("/")
    if path_array.length==1
      @current_path = "#{@pwd}/pikabu_temp.rb"
   else
    var = path_array[0..-2].join('/')
    @current_path = "#{@pwd}/#{var}/pikabu_temp.rb"
   end 
   @f = File.new("#{@current_path}", "w")
  end 

  def print_help
    puts 'Welcome to Pikabu! Please enter a command.'
    puts 'pikabu [file.rb]         : places a binding.pry if there is an error in your file'
    puts 'pikabu [file.rb] [line #]: places a binding.pry on the line number you specify'
  end

  def capture_stdout
    stdin, stdout, stderr = Open3.popen3("ruby #{@file_path}")
    @error = stderr.readlines 
      if @error == []
          puts "\nYou clever chicken! Pikabu detected no errors in your script!" 
          puts "\n"
          exec "rm #{@current_path}"
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
    system "ruby #{@current_path};rm #{@current_path}"
  end

end
