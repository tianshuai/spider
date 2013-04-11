# -*- coding:utf-8 -*-
require 'mongoid'
require 'kaminari/sinatra'
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

	#字段
	field :tab,			type: String
	field :title,	 	type: String
	field :url, 	 	type: String
	#field :user, 		type: Integer
	field :keyword,		type: String
	field :tags, 		type: Array
	field :state, 		type: Integer,	default: STATE[:no]
	field :type,		type: Integer,	default: TYPE[:spidr]
	#配置信息：options{:title='标题',desc=>'描述信息',img=>'图片路径'}
	field :config,		type: Hash,		default: {}

	#验证
	validates_presence_of :title ,:url
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

	#字段
	field :tab,			type: String
	field :title,	 	type: String
	field :desc,		type: String
	field :imgs,		type: String
	field :url, 	 	type: String
	field :keyword,		type: String
	field :state, 		type: Integer,	default: STATE[:no]
	field :type,		type: Integer,	default: 1


	#处理完的页面
	scope :compact,		where(state: STATE[:ok])
	#标识
	scope :have_tab,	lambda { |tab| any_in(tab: tab) }

	#验证
	#validates_presence_of :title ,:url

	##索引
    #index :tab, background: true
	#index :url, background: true

	##方法
	
	#网址是否存在
	def self.is_have?(url)
		return true if self.where(:url=>url).present?
		return false
	end

end
