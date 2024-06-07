-- To make script re-runnable
DROP TABLE IF EXISTS users;

-- Create a sample table
CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  username VARCHAR(50) NOT NULL UNIQUE,
  email VARCHAR(100) NOT NULL UNIQUE
);

-- Insert some sample data
INSERT INTO users (username, email) VALUES ('johndoe', 'johndoe@example.com'), ('janedoe', 'janedoe@example.com');
 