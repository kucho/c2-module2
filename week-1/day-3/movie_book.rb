# frozen_string_literal: true

# This is a command for this app
class Commands
  @@count = 0
  @@instances = []

  def initialize(class_name, name, desc)
    @class_name = class_name
    @name = name
    @desc = desc
    @@count += 1
    @@instances << self
  end

  attr_accessor :name, :desc, :class_name

  def self.all
    @@instances.inspect
  end

  def self.count
    @@count
  end

  def self.cmds
    @@instances.each(&:print_desc)
  end

  def self.valid?(cmd)
    @@instances.each do |i|
      next unless i.name == cmd

      case i.class_name
      when 'Movies'
        Movies.send(cmd)
      when 'Commands'
        Commands.send(cmd)
      end

      return
    end
    puts "Command #{cmd} is not valid, try again"
    false
  end

  def print_desc
    puts ">> Type '#{name}' to #{desc}"
  end

  def self.exit
    puts 'Bye...'
    Kernel.exit(0)
  end
end

# This is the parent class Movies
class Movies
  @@count = 0
  @@instances = []

  def self.all
    @@instances.inspect
  end

  def self.count
    @@count
  end

  def self.display
    @@instances.each { |i| i.send(:print) }
  end

  def self.exist?(movie)
    @@instances.each_with_index do |element, index|
      if element.name.downcase == movie.downcase
        return { found: true, pos: index }
      end
    end
    { found: false, pos: -1 }
  end

  def self.ask(text)
    puts text
    gets.chomp
  end

  def self.add
    movie = ask('What movie do you want to add?')
    if exist?(movie)[:found]
      puts 'Movie already exist'
      return
    end

    puts "What's the rating? (Type a number 0 to 5)"
    rating = gets.chomp.to_f.round(2)

    if rating.negative? || rating > 5
      puts 'Rating not valid'
      return false
    end

    Movie.new(movie, rating)
    puts "Movie #{movie} added"
  end

  def self.update
    movie = ask('What movie do you want to update?')
    res = exist?(movie)
    p 'Movie does not exist' unless res[:found]
    rating = ask("What's the new rating? (Type a number 0 to 5)").to_f.round(2)
    @@instances[res[:pos]].rating = rating
    if rating.negative? || rating > 5
      puts 'Rating not valid'
      return false
    end
    original_name = @@instances[res[:pos]].name
    puts "#{original_name} has been updated with new rating of #{rating}."
  end

  def self.delete
    movie = ask('What movie do you want to delete?')
    res = exist?(movie)
    p 'Movie does not exist' unless res[:found]
    original_name = @@instances[res[:pos]].name
    @@instances.delete_at(res[:pos])
    puts "#{original_name} has been removed."
  end
end

# This is a movie with a rating
class Movie < Movies
  def initialize(name, rating)
    @name = name
    @rating = rating
    @@count += 1
    @@instances << self
  end

  attr_accessor :name, :rating

  def print
    puts "#{name}: #{rating}"
  end
end

Commands.new('Movies', 'add', 'add a contact')
Commands.new('Movies', 'update', 'update a contact')
Commands.new('Movies', 'display', 'display all contacts')
Commands.new('Movies', 'delete', 'delete a contact')
Commands.new('Commands', 'cmds', 'list all the commands')
Commands.new('Commands', 'exit', 'abort')

puts 'What would you like to do?'
Commands.cmds

loop do
  input = gets.chomp
  Commands.valid?(input)
  puts '-----------------'
end
