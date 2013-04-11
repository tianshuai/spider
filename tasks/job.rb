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
					if WebRecord.is_have?(url.to_s)
						puts "have_url: #{m}"
						m+=1
					else

						if web.keyword.present?
							if url.to_s.include?(web.keyword)
								WebRecord.create(:tab=>args[:tag],:url=>url.to_s)
								puts "no_have_url: #{n}"
								n+=1
								i+=1
								s.pause! if i>100
							end
						else
							WebRecord.create(:tab=>args[:tag],:url=>url.to_s)
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
  task :analyse_page, [:tag,:type] do |t,args|
	require 'nokogiri'	
	require 'faraday'
	#require 'open-uri'
	args.with_defaults(:tag => 'def', :type => 1)
	puts '======start======='

	items = WebRecord.where(:tab=>args[:tag],:state=>WebRecord::STATE[:no])
	if items.present?
		i=0
		items.each do |item|
			web = WebInfo.where(:tab=>args[:tag])
			if web.present? and item.present? and item.url.present?
				web = web.first
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
					title = doc.css('title')
					if title.present?
						title = title.first.content
					else
						title = ''
					end
					img = doc.css('.SingleBigImage img')
					if img.present?
						img = img.first.attr('src') 
					else
						img = ''
					end
					desc = doc.css('.SingleArticleMainDescription')
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
				
			end
		end
	else

	end
	puts "============end================="
  end

end

