# encoding: utf-8
# 通过rake -T查看任务，前提是需要有desc描述
require 'sinatra'
require './app/app'
require './tasks/job'
=begin
#命令空间 Example
namespace :tian do
  desc "first:test"
  task :name do
    puts "name:tian"
  end
  
  desc "first:test1"
  #增加了顺序
  task :sex=>:name do
    puts "sex:male"
  end

  desc "first:test2"
  task :address=>:sex do
    puts "address:Beijing"
  end

  desc 'aaaaaaaaaa'
  task :moudle do
	puts 'aaaaaaaaaaaa'
	a = WebInfo.all
  end

end

=end
