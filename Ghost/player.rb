
class Player
  attr_accessor :losses
  attr_reader :name
  def initialize(name)
    @name = name
    @losses = 0
  end

  def show_word(word)
    puts "current word is '#{word}'. enter a letter"
  end

  def guess
    guess = ""
    until guess.length == 1
      guess = gets.chomp.downcase
      break if guess.length == 1
      puts "please enter valid input"
    end
    guess
  end

  def put_status
    print "#{name}:"
    ghost = "GHOST"
    puts ghost[0...losses]
  end
end

class ComputerPlayer < Player
  def initialize
    @name = "bot"
    @losses = 0
    @dictionary = File.readlines("dictionary.txt").map(&:chomp)
    @word = ""
  end

  def show_word(fragment)
    @word = fragment
    @dictionary.select! do |word|
      word[0...fragment.length] == fragment && word[fragment.length..-1].length.even?
    end
  end

  def guess
    if @dictionary.empty?
      return 'a'
    else
      return @dictionary.sample[@word.length]
    end
  end
end
