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

  def self.new_from_db(array)
    student = self.new
    student.id = array[0]
    student.name = array[1]
    student.grade = array[2]
  end
  # def update
  #   update_sql = "UPDATE students SET name = ?, grade = ? WHERE id = ?;"
  #   DB[:conn].execute(update_sql, self.name, self.grade, self.id)
  # end

  def save
    save_sql = <<-SQL
    INSERT INTO students (name, grade) VALUES (?, ?);
    SQL
    DB[:conn].execute(save_sql, self.name, self.grade)
    @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
  end

  def self.find_by_name(name)
    name_sql = "SELECT * FROM students WHERE name = ?;"
    DB[:conn].execute(name_sql, name).collect do |row|
      self.new_from_db(row)
    end

  end

end
