# encoding: utf-8

	helpers do
	  def page_title(name)
		"#{name}bar"
	  end
	end

	get '/' do
		settings.root
		@title = '首页'
		@a = settings.root

		erb :index
	end


	get '/list' do
		@title = '列表'
		@web_infos = WebInfo.all
		erb :list
	end

	get '/new' do
		@title = '新建页面'
		@spidr = WebInfo.new
		erb :new
	end

	post '/create' do
		@title = '表单创建'
		@web_info = WebInfo.new(params[:web_info])
		if @web_info.save
			redirect '/list'
		else
			redirect '/list'
		end
	end

	get '/edit/:id' do
		@web_info = WebInfo.find(params[:id])
		erb :edit
	end

	#资料库
	get '/web_list/:tab' do
		require 'kaminari/sinatra'
		require 'kaminari'
		@title = '资料库列表'
		@webs = WebRecord.have_tab(params[:tab]).page(params[:page]).per(50)
		erb :web_list
	end

	post '/update/:id' do
		@web_info = WebInfo.find(params[:id])
		if @web_info.update_attributes(params[:web_info])
			flash[:error] = '更新成功'
			redirect '/list'
		else
			#flash.new[:error] = '更新失败'
		end
		erb :edit
	end

	get '/destroy/:id' do
		@web_info = WebInfo.find(params[:id])
		if @web_info.present?
			@web_info.destroy
			redirect '/list'	
		else
			redirect '/list'
		end
	end
