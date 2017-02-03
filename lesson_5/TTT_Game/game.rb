require_relative 'modules'
require_relative 'board'
require_relative 'player'
require_relative 'score'
require_relative 'setup_game'
require_relative 'ttt_game'

game = TTTGame.new
game.play
