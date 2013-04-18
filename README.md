spider
======

spider 抓取网站图片

介绍：分为前台页面显示与后台的任务执行

操作步骤：
1.在该目录下打开 终端，首次执行需要安装gem，bundle install,启动命令：rackup ,默认端口号为9292
2.打开浏览器访问首页：127.0.0.1:9292 
3.点击‘新建’，创建要抓取网站的信息,添好各项内容
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


4.抓取网页执行的任务：rake tian:spider_img[tab,type];需要传入参数tab,type;tab是要抓取的网站标识，type为备用字段，不填默认为1

5.分析链接并抓取标题、描述及图片地址的任务：rake tian:analyse_page[tab,type]


