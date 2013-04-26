# -*- coding:utf-8 -*-
require 'mongoid'
require 'kaminari/sinatra'
require 'digest/md5'
Mongoid.load!(settings.config_dir + "/mongoid.yml")

class WebInfo
	include Mongoid::Document
  	include Mongoid::Timestamps
#	include Kaminari::MongoidExtension::Document

	#表名
	store_in collection: 'web_info'

	##常量
	#类型
	TYPE={
		spidr: 1,
		other: 2	
	}

	#状态
	STATE={
		#未处理的页面
		no: 0,
		#处理完成的页面
		ok: 1	
	}

	##字段
	#标识（执行rake任务时会传入此参数）
	field :tab,			type: String
	#标题
	field :title,	 	type: String
	#网站地址
	field :url, 	 	type: String
	#field :user, 		type: Integer
	#关键字（如果填写，抓取时只会取含有该关键字的Url）
	field :keyword,		type: String
	#标签（备用）
	field :tags, 		type: Array
	#状态
	field :state, 		type: Integer,	default: STATE[:no]
	#分类
	field :type,		type: Integer,	default: TYPE[:spidr]
	#配置信息(分析页面时会根据下列选择器抓取该网页下的标题、图片地址、描述等内容)
	#：options{:title='标题',desc=>'描述信息',img=>'图片路径'}
	field :config,		type: Hash,		default: {}

	#验证
	validates_presence_of :title ,:url,:tab

	index({ tab: 1 }, { unique: true, background: true })

end

class WebRecord
	include Mongoid::Document
  	include Mongoid::Timestamps
#	include Kaminari::MongoidExtension::Document

	#表名
	store_in collection: 'web_record'

	##常量

	#状态
	STATE={
		#未处理的页面
		no: 0,
		#处理完成的页面
		ok: 1	
	}

	##字段
	#标识 
	field :tab,			type: String
	#标题
	field :title,	 	type: String
	#描述
	field :desc,		type: String
	#图片地址，多张图片用,分开
	field :imgs,		type: String
	#源地址
	field :url, 	 	type: String
	#标签（多个标签用,分开）
	field :tags,		type: String
	#状态0，未处理的页面；1.处理完的页面
	field :state, 		type: Integer,	default: STATE[:no]
	#类型（备用）
	field :type,		type: Integer,	default: 1
	#索引（对url md5加密,用于索引）
	field :index,		type: String


	##过滤
	#处理完的页面
	scope :compact,		where(state: STATE[:ok])
	#标识
	scope :have_tab,	lambda { |tab| any_in(tab: tab) }

	#验证
	#validates_presence_of :title ,:url

	##索引
	index({ tab: 1 }, { unique: true, background: true })
	index({ index: 1 }, { background: true })

	##方法
	
	#网址是否存在
	def self.is_have?(url)
		index = Digest::MD5.hexdigest(url)
		return true if self.where(:index=>index).present?
		return false
	end

end
