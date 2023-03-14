# Welcome to My Users App
***

## Task
This is a web application written in Ruby that implements the MVC (Model View Controller) architecture using the Sinatra framework. It defines several HTTP endpoints that allow users to create, read, update, and delete user records stored in a SQLite database.

## Description

**Model**:  
The `my_user_model.rb` file defines the User class and the Database class that manages the SQLite database.

The Database class initializes an SQLite3 database and creates a new users table with columns for id, firstname, lastname, age, password, and email if the table doesn't exist.

The User class provides methods to create, find, update, and delete user records in the database. It also provides a method to convert a User object to a hash for JSON serialization.

**View**:  
The `index.erb` view is a template file for rendering a table of users on a web page. The file is written in HTML and embedded Ruby (ERB) code.

The view includes a table with four columns and the data for these columns is populated by parsing a JSON-formatted string of user information that is passed to the view.

The view loops through each user in the parsed JSON data and creates a new row in the table for each user, displaying their first name, last name, age, and email address in the appropriate columns.

**Controller**:  
The main file is `app.rb`, which defines the HTTP routes. Here's a brief summary of each HTTP endpoint:

**GET /:** This endpoint renders an HTML view that displays a list of all users in the database.

**GET /users:** This endpoint returns a JSON representation of all users in the database (without their passwords).

**POST /users:** This endpoint creates a new user record in the database based on the request parameters and returns a JSON representation of the new user (without the password).

**POST /sign_in:** This endpoint validates the user's credentials and creates a new session for the user if they are valid. It returns a JSON representation of the user (without the password).

**PUT /users:** This endpoint updates the current user's password. It requires the user to be authenticated (i.e., have an active session) and returns a JSON representation of the updated user (without the password).

**DELETE /sign_out:** This endpoint logs out the currently logged-in user.

**DELETE /users:** This endpoint logs out and deletes the currently logged-in user.

## Installation
Before running the application, you will need to have the following dependencies installed:

- Ruby
- SQLite3
- Sinatra

You can install these dependencies using your operating system's package manager and `gem install sinatra`.

Then clone the repository or download the source code.

## Usage
Navigate to the project directory in the terminal and run the following command to start the web application:

```
ruby app.rb
```

This will start a web server that listens on port `8080` by default.
You can then access the application in your web browser by navigating to http://localhost:8080/.

You can also run the following commands on the terminal:

Get all users:  
`curl localhost:8080/users`

Create a user:  
`curl -X POST localhost:8080/users -d firstname=Name -d lastname=LastName -d age=42 -d password=TidyObject76 -d email=email@domain.com`

Sign in with existing user credentials:  
`curl -X POST localhost:8080/sign_in -d email=email@domain.com -d password=TidyObject76`

Sign in and create a new user session:  
`curl -c cookies.txt -X POST localhost:8080/sign_in -d email=email@domain.com -d password=TidyObject76`

Changed password with active user session:  
`curl -b cookies.txt -X PUT localhost:8080/users -d email=email@domain.com -d password=changedpassword`

Sign out from active user session:  
`curl -b cookies.txt -X DELETE localhost:8080/sign_out`

Sign out from active user session and delete user:  
`curl -b cookies.txt -X DELETE localhost:8080/users`

### The Core Team

<span><i>Made at <a href='https://qwasar.io'>Qwasar SV -- Software Engineering School</a></i></span>
<span><img alt='Qwasar SV -- Software Engineering School's Logo' src='https://storage.googleapis.com/qwasar-public/qwasar-logo_50x50.png' width='20px'></span>
