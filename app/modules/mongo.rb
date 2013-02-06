# -*- coding:utf-8 -*-
require 'mongoid'
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
	STATUS={
		no: 0,
		ok: 1	
	}

	#字段
	field :title,	 	type: String
	field :url, 	 	type: String
	#field :user, 		type: Integer
	field :tags, 		type: Array
	field :status, 		type: Integer,	default: STATUS[:ok]
	field :type,		type: Integer,	default: TYPE[:spidr]

	#验证
	validates_presence_of :title ,:url
end
