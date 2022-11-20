# Creates game between 2 players
class TicTacToe
  def initialize(player1, player2)
    @markers = {}
    @player1 = get_player_data(player1, 1)
    @player2 = get_player_data(player2, 2)
    @players = [@player1, @player2]
    
    @board = [[1, 2, 3], [4, 5, 6], [7, 8, 9]]
  end

  def start_game
    i = 0
    current_player = @players[i]
    loop do
      display_board(@board)
      get_player_position(current_player)
      checked_board = check_board(@board)
      tied = @board.select do |element| 
        !element.select { |value| /[0-9]/.match(value.to_s) }
                .empty?
      end
                   .empty?
      if checked_board
        winning_player = @players.select { |player| player.marker == checked_board }
        puts("\nCongratulations #{winning_player.first.name} you have won the game!")
        break
      elsif tied
        puts("Tied!")
        break
      end
      i = (i + 1) % @players.length
      current_player = @players[i]
    end
  end

  private

  def get_player_data(player, n)
    name = nil
    marker = nil
    # Gets player name
    until name
      puts("Enter your name player##{n}:")
      name_input = gets.chomp
      if name_input.length < 3 
        puts("Error: Name under 3 characters.")
        divider
        redo
      end
      name = name_input
    end
    # Gets player game marker
    until marker
      puts("Enter your game marker which isnt from 0-9 and is 1 character:")
      puts("And isnt '#{@markers.keys.first}'") unless @markers.empty?
      marker_input = gets.chomp
      regex = /[a-z]/i.match(marker_input)
      unless (regex && !@markers.key?(marker_input)) && marker_input.length == 1
        puts("Error, enter different game marker.")
        divider
        redo
      end
      marker = marker_input
      @markers[marker] = n
    end
    player.name = name
    player.marker = marker
    player.number = n
    player
  end

  def display_board(board)
    row1 = board[0]
    row2 = board[1]
    row3 = board[2]

    puts("")
    row_divider
    puts("| #{row1[0]} | #{row1[1]} | #{row1[2]} |")
    row_divider
    puts("| #{row2[0]} | #{row2[1]} | #{row2[2]} |")
    row_divider
    puts("| #{row3[0]} | #{row3[1]} | #{row3[2]} |")
    row_divider
  end

  def get_player_position(player)
    position = nil
    until position
      puts("Where do you want to put your marker #{player.name}")
      position_input = gets.chomp
      unless /[0-9]/.match(position_input) && position_input.length == 1 && Integer(position_input).between?(0, 9)
        puts("Error: Input has to be a number between 0-9.")
        divider
        redo
      end
      position = set_marker(Integer(position_input), player.marker)
    end
  end

  def set_marker(position_input, marker)
    row = nil
    column = nil
    # * Gets the position of the number
    @board.find_index do |value|
      row = value
      column = value.find_index(position_input)
    end

    begin
      @board.dig(@board.find_index(row), column)
    rescue ::StandardError
      puts("Error: Invalid position #{position_input}.")
      divider
    else
      @board[@board.find_index(row)][column] = marker
    end
  end

  def check_board(board)
    checks = []
    checks.push(direction(board, 1, 1))
    checks.push(direction(board, 1, -1, 0, 2))
    # Rows and Rows
    board.each_with_index do |_, index|
      checks.push(direction(board, 0, 1, index))
      checks.push(direction(board, 1, 0, 0, index))
    end
    winning_marker = checks.select { |array| array.uniq.length == 1 }
                           .flatten
    winning_marker.first
  end

  def direction(board, row_increment = 0, column_increment = 0, row_i = 0, column_i = 0)
    row_index = row_i
    column_index = column_i
    checked_value = []
    until (row_index >= board.length || row_index.negative?) || (column_index >= board.length || column_index.negative?)
      checked_value.push(board[row_index][column_index])
      row_index += row_increment
      column_index += column_increment
    end
    checked_value
  end

  def row_divider
    puts("+---+---+---+")
  end

  def divider
    puts("-------------")
  end
end

class Player
  attr_accessor :name, :marker, :number
end

game = ::TicTacToe.new(::Player.new, ::Player.new)
game.start_game