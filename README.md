spider
======

spider 抓取网站图片

介绍：分为前台页面显示与后台的任务执行

操作步骤：
1.在该目录下打开 终端，首次执行需要安装gem，bundle install,启动命令：rackup ,默认端口号为9292
2.打开浏览器访问首页：127.0.0.1:9292 
3.点击‘新建’，创建要抓取网站的信息,添好各项内容，其中的‘标识’是你在后台执行任务时必需要传的参数


4.抓取网页执行的任务：rake tian:spider_img[tab,type]
5.分析链接执行的任务：rake tian:analyse_page[tab,type]


