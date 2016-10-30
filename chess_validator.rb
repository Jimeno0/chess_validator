require "pry"

#BOARD
class Board
  attr_reader :board
  def initialize(route)
    @aux_board =[]
    @board = [[],[],[],[],[],[],[],[]]
    get_board_from_txt(route)
    create_pieces_in_board
  end

  def get_board_from_txt(route)
    f = File.open(route, "r")
    f.each_line do |line|
      @aux_board.push(line.chomp.split(" "))
    end
    f.close

    for x in 0..7
      for y in 0..7
        @board[x][y] = @aux_board[y][x]
      end
    end

  end

  def create_pieces_in_board
    for x in 0..7
      for y in 0..7
        check_string_then_create_piece(x,y,@board[x][y])
      end
    end
  end

  def check_string_then_create_piece(x,y,str)
    
    type = str.chars[1]
    color = str.chars[0]
    
    if type == "R"
      @board[x][y] = Rook.new([x,y])
    elsif type == "N"
      @board[x][y] = Knight.new([x,y])
    elsif type == "B"
      @board[x][y] = Bishop.new([x,y])
    elsif type == "Q"
      @board[x][y] = Queen.new([x,y])
    elsif type == "K"
      @board[x][y] = King.new([x,y])
    elsif type == "P"
      @board[x][y] = Pawn.new([x,y],color)
    else
      @board[x][y] = nil
    end
  end 
end

#POSITION TRANSLATOR
class Position_translator
  def self.translate(string)
    string_arr = string.chars
    xpos = string_arr[0].ord - 97
    ypos =  8 - string_arr[1].to_i
    [xpos,ypos]
  end
end

#VALIDATOR
class ChessValidator

  def initialize(route)
    @positions
    get_positions_pairs(route)
  end

  def get_positions_pairs(route)
    f = File.open(route, "r")
    @positions = []
    f.each_line do |line|
      @positions.push(line.chomp.split(" "))
    end
    f.close  
  end

  def check_positions(board)

    @positions.each do |positions_pair|

      initial = Position_translator.translate(positions_pair[0])
      final = Position_translator.translate(positions_pair[1])
      
      piece_to_validate = board[initial[0]][initial[1]]
      destiny_to_validate = board[final[0]][final[1]]

      if piece_to_validate!= nil
        # puts piece_to_validate.piece_movement_allowed?(final)

        if piece_to_validate.piece_movement_allowed?(final)

          if destiny_to_validate!= nil
            puts "ILLEGAL (piece at destiny place)"
          else
            puts "LEGAL (empty destiny)"
          end
        else
        puts "ILLEGAL (movement not allowed for this piece)"
        end 
      else
        puts "ILLEGAL (null position)"
      end
    end
  end
end



#SHARED MOVEMENT MODULES
module Rook_move
  def rook_moves(from)
    for y in 0..7
      @available_moves.push([from[0],y])
      @available_moves.delete(from)
    end

    for x in 0..7
      @available_moves.push([x,from[1]])
      @available_moves.delete(from)
    end
    @available_moves
  end
end

module Bishop_move
  def bishop_moves(from)
    dif = from[0] - from[1]
    sum = from[0] + from[1]

    # First diagonal
    for i in 0..7
      x = dif + i
      y = i
      if x <8  && y < 8 && x >= 0 && y >= 0
        @available_moves.push([x,y])  
      end
    end

    # Second diagonal
    for i in 0..sum
      x = i
      y = sum - i
      if x <8  && y < 8 && x >= 0 && y >= 0
        @available_moves.push([x,y])  
      end
    end
    #Return moves
    @available_moves.delete(from)
    @available_moves
  end
end

#PIECES
class ChessPiece
  def initialize(from)
    @available_moves = []
    get_moves(from)
  end

  def piece_movement_allowed?(finPos)
    if @available_moves.include?(finPos)
      true
    else
      false
    end
  end
end

class Pawn < ChessPiece
  def initialize(from,color)
    @color = color
    super(from)
    
  end

  def get_moves(from)
    #color y 2 move
    if @color == "b"
    @available_moves.push([from[0],from[1]+1])
      if from[1] == 1
        @available_moves.push([from[0],from[1]+2])
      end
    else
      @available_moves.push([from[0],from[1]-1])
      if from[1] == 6
        @available_moves.push([from[0],from[1]-2])
      end
    end
    @available_moves
  end
end

class King < ChessPiece
  def get_moves(from)

    for x in (from[0]-1)..(from[0]+1)
      for y in (from[1]-1)..(from[1]+1)  
        @available_moves.push([x,y])        
      end
    end
    @available_moves.delete(from)
    @available_moves
  end
end

class Knight < ChessPiece

  def get_moves(from)
    

    pos1 = [from[0]-2,from[1]-1]
    pos2 = [from[0]-2,from[1]+1]
    pos3 = [from[0]-1,from[1]-2]
    pos4 = [from[0]-1,from[1]+2]

    pos5 = [from[0]+1,from[1]-2]
    pos6 = [from[0]+1,from[1]+2]
    pos7 = [from[0]+2,from[1]-1]
    pos8 = [from[0]+2,from[1]+1]

    positions = [pos1,pos2,pos3,pos4,pos5,pos6,pos7,pos8]
    positions.each do |pos|
      if pos[0] <8  && pos[1] < 8 && pos[0] >= 0 && pos[1] >= 0
        @available_moves.push(pos)
      end
    end
  end
end

class Rook < ChessPiece
  include Rook_move

  def get_moves(from)
    rook_moves(from)
  end
end


class Bishop < ChessPiece
  include Bishop_move

  def get_moves(from)
    bishop_moves(from)
  end
end

class Queen <ChessPiece
  include Rook_move
  include Bishop_move

  def get_moves(from)
    rook_moves(from)
    bishop_moves(from)
  end
end

#Peon. comprobar color a ver si mueve para arriba o para abajo. comprobar posivion inical para mover dos o no
#si se sale del tablero el moviemiento, podria ser que vaya a a entrar 
#por el otro extremo del tablero en el peon y rey y eso hay que arreglarlo tambien (dejar para el final la comparacion con si hay otra ficha, así podemos hacer que no pete???)



my_board = Board.new("basic_board.txt")

validate = ChessValidator.new("basic_positions.txt")
validate.check_positions(my_board.board)

binding.pry
puts "testing"