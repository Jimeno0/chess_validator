require "pry"

#BOARD && POSITION TRANSLATOR
class Board
  def initialize(route)
    @board =[]
    get_board_from_txt(route)
    create_pieces_in_board
  end

  def get_board_from_txt(route)
    f = File.open(route, "r")
    txt_arr = []
    f.each_line do |line|
      @board.push(line.chomp.split(" "))
    end
    f.close
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
      @board[x][y] = Pawn.new([x,y])
    else
      @board[x][y] = nil
    end
  end 
end

class Position_translator
  def self.translate(string)
    string_arr = string.chars
    xpos = string_arr[0].ord - 97
    ypos =  8 - string_arr[1].to_i
    [xpos,ypos]
  end
end

class ChessValidator
  def self.validate(route)
    f = File.open(route, "r")
    txt_arr = []
    f.each_line do |line|
      @board.push(line.chomp.split(" "))
    end
    f.close
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




class ChessPiece
  def initialize(from)
    @available_moves = []
    get_moves(from)
  end

  def piece_movement_allowed?(finPos)
    @available_moves.include?(finPos)
  end
end

class Pawn < ChessPiece
  def get_moves(from)
    #Peon. comprobar color a ver si mueve para arriba o para abajo. comprobar posivion inical para mover dos o no
    @available_moves.push(from[0],from[1]-1)
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


# my_pawn = Pawn.new(Position_translator.translate("c7"))
# my_king = King.new(Position_translator.translate("c7"))
# my_rook = Rook.new(Position_translator.translate("c7"))
# my_bishop = Bishop.new(Position_translator.translate("c7"))
# my_knight = Knight.new(Position_translator.translate("c7"))
# my_queen = Queen.new(Position_translator.translate("c7"))

# puts Position_translator.translate("c7")

# puts  "-------"

# #Sample
# board = [
#           ["a8","b8","c8","d8","e8","f8","g8","h8"],
#           ["a7","b7","c7","d7","e7","f7","g7","h7"],
#           ["a6","b6","c6","d6","e6","f6","g6","h6"],
#           ["a5","b5","c5","d5","e5","f5","g5","h5"],
#           ["a4","b4","c4","d4","e4","f4","g4","h4"],
#           ["a3","b3","c3","d3","e3","f3","g3","h3"],
#           ["a2","b2","c2","d2","e2","f2","g2","h2"],
#           ["a1","b1","c1","d1","e1","f1","g1","h1"],
# ]


my_board = Board.new("basic_board.txt")

# ChessValidator.validate("basic_positions.txt")

binding.pry
puts "teting"