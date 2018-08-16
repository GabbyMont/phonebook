require 'pg'
load './local_env.rb' if File.exist?('./local_env.rb')


def insert_info(data)
	begin
		db_info = {
			host: ENV['RDS_HOST'],
			port: ENV['RDS_PORT'],
			dbname: ENV['RDS_DB_NAME'],
			user: ENV['RDS_USERNAME'],
			password: ENV['RDS_PASSWORD']
		}
		d_base = PG::Connection.new(db_info)
		d_base.exec("INSERT INTO public.user_info
		(fname, lname, st_address, city, state, zip_code, phonenum, email)
		VALUES('#{data[0]}','#{data[1]}','#{data[2]}','#{data[3]}','#{data[4]}','#{data[5]}','#{data[6]}','#{data[7]}');");
	rescue PG::Error => e
		puts e.message
	ensure
		d_base.close if d_base
	end
end

def update_info(data, olddata)
	begin
	db_info = {
		host: ENV['RDS_HOST'],
		port: ENV['RDS_PORT'],
		dbname: ENV['RDS_DB_NAME'],
		user: ENV['RDS_USERNAME'],
		password: ENV['RDS_PASSWORD']
    }
	d_base = PG::Connection.new(db_info)
	d_base.exec ("UPDATE public.user_info
	SET fname='#{data[0]}', lname='#{data[1]}', st_address='#{data[2]}', city='#{data[3]}', state='#{data[4]}', zip_code='#{data[5]}', phonenum='#{data[6]}', email='#{data[7]}' WHERE email='#{olddata[7]}'");
	rescue PG::Error => e
		puts e.message
    ensure
		d_base.close if d_base
	end
end

def select_from_table()
	begin
		db_info = {
			host: ENV['RDS_HOST'],
			port: ENV['RDS_PORT'],
			dbname: ENV['RDS_DB_NAME'],
			user: ENV['RDS_USERNAME'],
			password: ENV['RDS_PASSWORD']
		}
		d_base = PG::Connection.new(db_info)
		list = d_base.exec("SELECT fname,lname,st_address,city,state,zip_code,phonenum,email FROM public.user_info")
	rescue PG::Error => e
		puts e.message
	ensure
		d_base.close if d_base
	end
end 


def delete_info(data)
	begin
		db_info = {
			host: ENV['RDS_HOST'],
			port: ENV['RDS_PORT'],
			dbname: ENV['RDS_DB_NAME'],
			user: ENV['RDS_USERNAME'],
			password: ENV['RDS_PASSWORD']
		}
		d_base = PG::Connection.new(db_info)
		list = d_base.exec("DELETE FROM public.user_info
		WHERE fname='#{data[0]}' AND lname='#{data[1]}' AND st_address='#{data[2]}' AND city='#{data[3]}' AND state='#{data[4]}' AND zip_code='#{data[5]}' AND phonenum='#{data[6]}' AND email='#{data[7]}'");           
	rescue PG::Error => e
		puts e.message
	ensure
		d_base.close if d_base
	end
end 

def check_if_user_is_in_db(data)
	begin
	db_info = {
		host: ENV['RDS_HOST'],
		port: ENV['RDS_PORT'],
		dbname: ENV['RDS_DB_NAME'],
		user: ENV['RDS_USERNAME'],
		password: ENV['RDS_PASSWORD']
	}
	d_base = PG::Connection.new(db_info)
	d_base.exec ("SELECT * FROM public.user_info WHERE lname = '#{data[1]}' AND phonenum = '#{data[6]}' OR email = '#{data[7]}';")
	rescue PG::Error => e
		puts e.message
	ensure
		d_base.close if d_base
	end
end

# def login(username,password)
# 	begin
# 		db_info = {
# 			host: ENV['RDS_HOST'],
# 			port: ENV['RDS_PORT'],
# 			dbname: ENV['RDS_DB_NAME'],
# 			user: ENV['RDS_USERNAME'],
# 			password: ENV['RDS_PASSWORD']
# 		}
# 	end
# 	db = PG::Connection.new(db_info)
# 	encrypted_pass = BCrypt::Password.create(password, :cost => 11)
# 	checkUser = db.exec("SELECT username FROM login WHERE username = '#{username}'")
# 	if checkUser.num_tuples.zero? == true
# 		db.exec ("INSERT INTO login (username, password) VALUES ('#{username}','#{encrypted_pass}')")
# 		puts "New row added #{encrypted_pass}"
# 	else
# 		db.close
# 		puts "Name already exists"
# 	end
# end

def update_login_table(data)
	begin
		db_info = {
			host: ENV['RDS_HOST'],
			port: ENV['RDS_PORT'],
			dbname: ENV['RDS_DB_NAME'],
			user: ENV['RDS_USERNAME'],
			password: ENV['RDS_PASSWORD']
		}
		d_base = PG::Connection.new(db_info)
		d_base.exec("UPDATE public.login
		SET username='#{data[0]}', password='#{data[1]}';");            
	rescue PG::Error => e
		puts e.message
	ensure
		d_base.close if d_base
	end  
end

def select_from_login_table(data)
	begin
		db_info = {
			host: ENV['RDS_HOST'],
			port: ENV['RDS_PORT'],
			dbname: ENV['RDS_DB_NAME'],
			user: ENV['RDS_USERNAME'],
			password: ENV['RDS_PASSWORD']
		}
		d_base = PG::Connection.new(db_info)
		list = d_base.exec("SELECT username,password FROM public.login")
	rescue PG::Error => e
		puts e.message
	ensure
		d_base.close if d_base
	end
end 

def delete_login_info(data)
	begin
		db_info = {
			host: ENV['RDS_HOST'],
			port: ENV['RDS_PORT'],
			dbname: ENV['RDS_DB_NAME'],
			user: ENV['RDS_USERNAME'],
			password: ENV['RDS_PASSWORD']
		}
		d_base = PG::Connection.new(db_info)
		list = d_base.exec("DELETE FROM public.login
		WHERE username='#{data[0]}';")           
	rescue PG::Error => e
		puts e.message
	ensure
		d_base.close if d_base
	end
end 