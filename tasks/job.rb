# encoding: utf-8
# 通过rake -T查看任务，前提是需要有desc描述

#命令空间 Example
namespace :tian do

  #测试
  desc 'add_db-------test'
  task :web_info_add do
	puts '=====start====='
	(1..10).each do |a|
		WebInfo.create({tab: "a#{a}",title: "test#{a}",url: "www.#{a}.com"})
	end
	puts WebInfo.all.size
  end

  #抓取网页（需传入参数：tag=>网站标识，type=>还未定义）
  desc 'spider_img'
  task :spider_img, [:tag,:type] do |t,args|
	require 'spidr'
	args.with_defaults(:tag => 'def', :type => 1)
	puts '======start======='
	web = WebInfo.where(:tab=>args[:tag])
	if web.present?
		web=web.first
		i,m,n=0,0,0
		Spidr.site(web.url) do |s|
			if s.present?
				puts 'have spidr'
				s.every_url do |url|
					#判断这个页面是否存在数据库，如果存在则跳过，不存在则创建
					if url.to_s[-1]=='/'
						url = url.to_s[0,url.to_s.size-1]
					else
						url = url.to_s
					end
					if WebRecord.is_have?(url)
						puts "have_url: #{m}"
						m+=1
					else

						if web.keyword.present?
							if url.to_s.include?(web.keyword)
								WebRecord.create(:tab=>args[:tag],:url=>url)
								puts "no_have_url: #{n}"
								n+=1
								i+=1
								s.pause! if i>100
							end
						else
							WebRecord.create(:tab=>args[:tag],:url=>url)
							puts "new_page: #{n}"
							n+=1
							puts i
							i+=1
							s.pause! if i>100
						end
					end
				end
			else
				puts 'no_have_spidr'
			end
			puts 'spider-----end'
		end
	end

  end

  #分析页面 （需传入参数：tag=>网站标识，type=>还未定义）
  desc "fetch_info"
  task :fetch_info, [:tag,:type] do |t,args|
	require 'nokogiri'	
	require 'faraday'
	#require 'open-uri'
	args.with_defaults(:tag => 'def', :type => 1)
	puts '======start======='

	web = WebInfo.where(:tab=>args[:tag])
	if web.present?
		web = web.first
		title_f = web.config['title']
		desc_f = web.config['desc']
		img_f = web.config['img']

		items = WebRecord.where(:tab=>args[:tag],:state=>WebRecord::STATE[:no])
		if items.present?
			i=0
			items.each do |item|
				response = Faraday.get(item.url)

				case response.status
				when 200
				  html = response.body
				  puts '200'
				when 301..302
					puts '302'
				  html = Faraday.get(response[:location]).body
				end

				doc = Nokogiri::HTML(html)
				if doc.present?
					title = doc.css(title_f)
					if title.present?
						title = title.first.content
					else
						title = ''
					end
					img = doc.css(img_f)
					if img.present?
						img = img.first.attr('src') 
					else
						img = ''
					end
					desc = doc.css(desc_f)
					if desc.present?
						desc = desc.first.content 
					else
						desc = ''
					end
					i+=1
					#puts doc
					puts "num: #{i}"
				end
				options = {
					:title=>title,
					:imgs=>img,
					:desc=>desc
				}
				puts "url: #{item.url}"
				puts "title: #{options[:title]}"
				puts "img: #{options[:imgs]}" 

				item.update_attributes(options)
					
			end#loop_end
		end#if items_end
	end#if web.present?
	puts "============end================="
  end


  ##下载图片保存到本地
  desc "down_img"
  task :down_img, [:tag,:type] do |t,args|
	args.with_defaults(:tag => 'def', :type => 1)
	require 'open-uri'
	require 'mini_magick'
	puts '======start======='
	items = WebRecord.where(:tab=>args[:tag],:state=>WebRecord::STATE[:no])

	items.each_with_index do |item,index|
		if item.present? and item.imgs.present?
			#response = Faraday.get(item.imgs)
			ext = item.imgs.split('.').last
			file_name = "#{Time.now.to_i.to_s}#{rand(10000)}.#{ext}"
			path = "/extend/images/sheji_new/#{file_name}"
			#File.new(path,'w')
			

			image_io= open(item.imgs)

			image_mini = MiniMagick::Image.read(image_io)
			#	image_mini.combine_options do |img|
			#		img.quality '100'
			#	end
			image_mini.write(path)
			#return false if index>2

		end
	end

  end

  ##测试
  desc 'test'
  task :test do
	require 'nokogiri'	
	require 'faraday'
	puts 'begin'
	#path = settings.root
	path = '/extend/bathroom.htm'
	html = open(path)
	doc = Nokogiri::HTML(html)
	puts doc.at_css('title').text
        m = /dsz\.contents\.push[^;]+/

	puts doc.at_css('html').content.scan(m).first
	#puts doc.css('script')[34].content


  end


  ##更新数据
  desc "update_data"
  task :update_data, [:tag,:type] do |t,args|

	puts '======start======='
	items = WebRecord.where(:tab=>args[:tag],:state=>WebRecord::STATE[:no])

	items.each_with_index do |item,index|
		if item.present?
			item.destroy	

		end
	end

  end


end

