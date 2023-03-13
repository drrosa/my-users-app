require "sqlite3"

$db_name = "db.sql" 
$table_name = "users"

class Database
    attr_reader :sqlite_db

    def initialize
        @sqlite_db ||= SQLite3::Database.new $db_name
        query = <<~SQL
        CREATE TABLE IF NOT EXISTS #{$table_name} (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            firstname VARCHAR(255),
            lastname VARCHAR(255),
            age INTEGER,
            password VARCHAR(255),
            email VARCHAR(255)
        );
        SQL
        @sqlite_db.execute(query)
    end
end

class User
    attr_accessor :id, :firstname, :lastname, :age, :password, :email

    def initialize(id, firstname, lastname, age, password, email)
        @id = id
        @firstname = firstname
        @lastname = lastname
        @age = age.to_i
        @password = password
        @email = email
    end

    def inspect
        "{id: #{@id}, firstname: #{@firstname}, :lastname #{@lastname}, age: #{@age}, password: #{@password}, email:#{@email}}"
    end

    def self.to_hash(user)
        user = {
            id: user.id,
            firstname: user.firstname,
            lastname: user.lastname,
            age: user.age,
            email: user.email
        }
    end

    def self.create(user_info)
        @DB = Database.new.sqlite_db
        query = <<~SQL
            INSERT INTO #{$table_name} (firstname, lastname, age, password, email)
            VALUES (?, ?, ?, ?, ?)
        SQL
        user = User.new 0, *user_info.values
        @DB.execute(query, user_info.values)
        user.id = @DB.last_insert_row_id
        return user
    end

    def self.find(user_id)
        @DB ||= Database.new.sqlite_db
        query = <<~SQL
            SELECT *
            FROM #{$table_name}
            WHERE id = ?
        SQL
        return nil unless (rows = @DB.execute(query, user_id)).any?
        return User.new *rows.first
    end

    def self.update(user_id, attribute, value)
        @DB ||= Database.new.sqlite_db
        user = find(user_id)
        return nil unless user
        
        query = <<~SQL
          UPDATE #{$table_name}
          SET #{attribute} = ?
          WHERE id = ?
        SQL
        
        @DB.execute(query, [value, user_id])
        attribute = "@" + attribute.to_s
        user.instance_variable_set(attribute, value)
        return user
    end

    def self.all
        @DB ||= Database.new.sqlite_db
        query = <<~SQL
            SELECT *
            FROM #{$table_name}
        SQL

        users = []
        @DB.execute(query).each do |row|
            user = User.new(*row)
            users << user
        end
        return users
    end

    def self.destroy(user_id)
        @DB ||= Database.new.sqlite_db
        query = <<~SQL
            DELETE
            FROM #{$table_name}
            WHERE id=?
        SQL
        @DB.execute(query, user_id)
    end
end