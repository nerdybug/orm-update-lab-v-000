require_relative "../config/environment.rb"

class Student

  attr_accessor :name, :grade
  attr_reader :id

  def initialize(name, grade, id=nil)
    @name = name
    @grade = grade
    @id = id
  end

  def self.create_table
    table_sql = <<-SQL
    CREATE TABLE students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade INTEGER
    );
    SQL
    DB[:conn].execute(table_sql)
  end

  def self.drop_table
    drop_sql = <<-SQL
    DROP TABLE students;
    SQL
    DB[:conn].execute(drop_sql)
  end

  def save(name:, grade:)
    save_sql = <<-SQL
    INSERT INTO students (name, grade) VALUES (?, ?);
    SQL
    DB[:conn].execute(save_sql, name, grade)
    @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
  end

end
