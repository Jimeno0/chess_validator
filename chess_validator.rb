require "pry"

class Board
  def initialize(arr_of_arr)
    @board = arr_of_arr
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


class ChessPiece
  def initialize
    @available_moves = []
  end
end

class Pawn < ChessPiece
  def can_move_to(from)
    @available_moves.push(from[0],from[1]-1)
    @available_moves
  end
end

class King < ChessPiece
  def can_move_to(from)

    for x in (from[0]-1)..(from[0]+1)
      for y in (from[1]-1)..(from[1]+1)  
        @available_moves.push([x,y])        
      end
    end
    @available_moves.delete(from)
    @available_moves
  end
end







my_pawn = Pawn.new
my_king = King.new

puts Position_translator.translate("h1")
puts  "-------"
puts my_pawn.can_move_to(Position_translator.translate("b7"))
puts my_king.can_move_to(Position_translator.translate("b7"))

#Sample
board = [
          ["a8","b8","c8","d8","e8","f8","g8","h8"],
          ["a7","b7","c7","d7","e7","f7","g7","h7"],
          ["a6","b6","c6","d6","e6","f6","g6","h6"],
          ["a5","b5","c5","d5","e5","f5","g5","h5"],
          ["a4","b4","c4","d4","e4","f4","g4","h4"],
          ["a3","b3","c3","d3","e3","f3","g3","h3"],
          ["a2","b2","c2","d2","e2","f2","g2","h2"],
          ["a1","b1","c1","d1","e1","f1","g1","h1"],
]
binding.pry
puts "teting"