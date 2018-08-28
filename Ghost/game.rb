require "set"
require_relative 'player'
require 'byebug'

class Game
  attr_reader :current_player

  def initialize(players)
    @words = File.readlines("dictionary.txt").map(&:chomp)
    @fragment = ""
    @players = players
    @current_player = @players[0]
  end

  def run
    while @players.none? {|player| player.losses >= 5 }
      play_round
    end
    winners = @players.reject {|player| player.losses >= 5 }
    puts "#{winners[0].name} wins"
  end

  def add_letter(letter)
    @fragment << letter
    @words = @words.select {|word| word[0...@fragment.length] == @fragment}
  end

  def play_round
    while true
      @current_player.show_word(@fragment)
      letter = @current_player.guess
      break unless valid_play?(letter)
      add_letter(letter)
      next_player!
    end
    puts "#{@current_player.name} lost the round"
    @current_player.losses += 1
    @players.each {|player| player.put_status}
    @fragment = ""
    @words = File.readlines("dictionary.txt").map(&:chomp)
  end

  def next_player!
    @current_player = @current_player == @players[0] ? @players[1] : @players[0]
  end

  def full_word
    @words.include?(@fragment)
  end

  def valid_play?(letter)
    @words.select {|word| word[0..@fragment.length] == @fragment + letter}.length > 0
  end
end

if __FILE__ == $PROGRAM_NAME
  player1 = Player.new('bob')
  player2 = ComputerPlayer.new
  game = Game.new([player1, player2])
  game.run
end
