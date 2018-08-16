require 'sinatra'
require_relative 'db_functions.rb'
require_relative 'user_info.rb'
enable :sessions

User = Struct.new(:id, :username, :password_hash)
USERS = [
	User.new(1, 'ice', hash_password('cream')),
	User.new(2, 'brownie', hash_password('bites')),
]

get '/' do
	# "hello world"
	erb :enter
end

post '/enter' do
	# "you are in post enter"
	redirect '/sign_in'
end

get '/sign_in' do
	puts "in get signin params is #{params}"
	session[:username] = params[:username]
	session[:password] = params[:password]
	message = params[:message] || ""
	puts "about to leave signin and session[:username] is #{session[:username]} and session[:password] is #{session[:password]} and message is #{message}"
	erb :login, locals: {message: message, username: session[:username], password: session[:password]}
end

post '/create_user' do
	puts "in post create_user, params is #{params}"
	session[:username] = params[:username]
	session[:password] = params[:password]
	p "this is session [:usernsmein create password!!!!!!!! #{session[:username]}"
	p "this is session password in create password!!!!!!!! #{session[:password]}"
	
	# p "#{session[:username]} &&&&&&&&&&&&&  (#{session[:password]})"
	# login = login(session[:username], session[:passoword])
	# p "i am the login #{login}"

	db_info = {
		host: ENV['RDS_HOST'],
		port: ENV['RDS_PORT'],
		dbname: ENV['RDS_DB_NAME'],
		user: ENV['RDS_USERNAME'],
		password: ENV['RDS_PASSWORD']
	}
	d_base = PG::Connection.new(db_info)
	encrypted_pass = BCrypt::Password.create(session[:password], :cost => 11)
	checkUser = d_base.exec("SELECT username FROM login WHERE username = '#{session[:username]}'")
	if checkUser.num_tuples.zero? == true
		puts "checkUser.num_tuples.zero? == true"
		d_base.exec ("INSERT INTO login (username, password) VALUES ('#{session[:username]}','#{encrypted_pass}')")
		puts "New row added #{encrypted_pass}"
		redirect '/sign_in'

	else
		puts "checkUser.num_tuples.zero? == false"
		d_base.close
		redirect '/sign_in?message=User Already Exists'
		# puts "Name already exists"
	end
end

post '/sign_in' do
	puts "in post signin params are #{params}"
	session[:username] = params[:username]
	session[:password] = params[:password]
	db_info = {
		host: ENV['RDS_HOST'],
		port: ENV['RDS_PORT'],
		dbname: ENV['RDS_DB_NAME'],
		user: ENV['RDS_USERNAME'],
		password: ENV['RDS_PASSWORD']
	}
	puts "session[:username] is #{session[:username]} and session[:password] is #{session[:password]}"
	d_base = PG::Connection.new(db_info)
	user_name = session[:username]
	user_pass = session[:password]
	match_login = d_base.exec("SELECT username, password FROM login WHERE username = '#{session[:username]}'")
	if match_login.num_tuples.zero? == true
		puts "in post signin match_login.num_tuples.zero? == true"
		error = erb :login,locals: {message:"invalid username and password combination"}
		# puts "namepassword combo does not exist"
		return error
	end
	password = match_login[0]['password']
	comparePassword = BCrypt::Password.new(password)
	usertype = match_login[0]['usertype']
	if match_login[0]['username'] == user_name &&  comparePassword == user_pass
		puts "match_login[0]['username'] == user_name &&  comparePassword == user_pass"
		session[:username] = user_name
		erb :inputinfo
	else
		puts "in the else, doesn't match"
		erb :login,locals: {message:"invalid username and password combination"}
	end
	# redirect '/'
end

get '/input_info' do
	erb :inputinfo
end

post '/input_info' do
	session[:data] = params[:data]
	db_check = check_if_user_is_in_db(session[:data])
	if db_check.num_tuples.zero? == true
		puts "Putting in db b/c information not found"
		insert_info(session[:data])
		redirect '/final_result'
	else
		redirect '/updates'
	end
end

get '/updates' do
	db_check = check_if_user_is_in_db(session[:data]).values[0]
	erb :update, locals: {db_check: db_check}
end

post '/updates' do
	session[:newdata] = params[:data]
	update_info(session[:newdata],session[:data])
	redirect '/final_result'
end

post '/delete' do
	delete_info(check_if_user_is_in_db(session[:data]).values[0])
	redirect '/final_result'
end

get '/final_result' do
	db_return = select_from_table()
	erb :post_info, locals: {db_return: db_return}
end

post '/final_result' do
	redirect '/input_info'
end