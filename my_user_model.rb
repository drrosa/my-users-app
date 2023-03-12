require "sqlite3"

class Database
    attr_reader :sqlite_db

    def initialize
        @sqlite_db ||= SQLite3::Database.new "db.sql" 
        query = <<~SQL
        CREATE TABLE IF NOT EXISTS users (
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
    attr_accessor :id, :firstname, :lastname, :age, :email

    def initialize(id, firstname, lastname, age, password, email)
        @id = id
        @firstname = firstname
        @lastname = lastname
        @age = age
        @email = email
    end

    def self.create(user_info)
        @DB = Database.new.sqlite_db
        query = <<~SQL
            INSERT INTO users (firstname, lastname, age, password, email)
            VALUES (?, ?, ?, ?, ?)
        SQL
        user = User.new 0, *user_info.values
        @DB.execute(query, user_info.values)
        user.id = @DB.last_insert_row_id
        return user
    end

    def self.find(user_id)
        query = <<~SQL
            SELECT *
            FROM users
            WHERE id = ?
        SQL
        user_info = @DB.execute(query, user_id).first
        user = User.new *user_info
        return user
    end

    def self.update(user_id, attribute, value)
        user = find(user_id)
        return nil unless user
        
        query = <<~SQL
          UPDATE users
          SET #{attribute} = ?
          WHERE id = ?
        SQL
        
        @DB.execute(query, [value, user_id])
        user = find(user_id)
        return user
    end

    def self.all
        query = <<~SQL
            SELECT *
            FROM users
        SQL

        users = {}
        @DB.execute(query).each do |row|
            
            user = {
                id: row[0],
                firstname: row[1],
                lastname: row[2],
                age: row[3],
                password: row[4],
                email: row[5]
            }
            users[row[0]] = user
        end
        return users
    end

    def self.destroy(user_id)
        query = <<~SQL
            DELETE
            FROM users
            WHERE id=?
        SQL
        @DB.execute(query, user_id)
    end
end