class User
    attr_accessor :first_name, :last_name, :id, :age
  def initialize(first_name, last_name, id, age)
    @first_name = first_name
    @last_name = last_name
    @id = id
    @age = age
  end
end

class Users
    attr_accessor :all_users
  def initialize
    @all_users = [
      {:first_name => "Andy",    :last_name => "Roddick", :id => "1", :age => "33"},
      {:first_name => "Pete",    :last_name => "Sampras", :id => "2", :age => "44"},
      {:first_name => "Andre",   :last_name => "Agassi",  :id => "3", :age => "45"},
      {:first_name => "James",   :last_name => "Blake",   :id => "4", :age => "36"},
      {:first_name => "Todd",    :last_name => "Martin",  :id => "5", :age => "45"},
      {:first_name => "Michael", :last_name => "Chang",   :id => "6", :age => "44"},
      {:first_name => "Patrick", :last_name => "McEnroe", :id => "7", :age => "57"},
      {:first_name => "John",    :last_name => "McEnroe", :id => "8", :age => "49"}
    ]
  end

  def all
    @all_users
  end
end

Users.new.all
