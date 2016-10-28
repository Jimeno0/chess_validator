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

class Rook < ChessPiece
  def can_move_to(from)
    for y in 0..7
      @available_moves.push([from[0],y])
      @available_moves.delete(from)
    end

    for x in 0..7
      @available_moves.push([x,from[0]])
      @available_moves.delete(from)
    end
    @available_moves
  end
end


class Bishop < ChessPiece
  def can_move_to(from)
    
    dif = from[0] - from[1]
    sum = from[0] + from[1]

    # First diagonal
    for i in 0..7
      x = dif + i
      y = i
      if x <8  && y < 8 && x >= 0 && y >= 0
        @available_moves.push([x,y])  
      end
      if x == 7
        break
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

    @available_moves.delete(from)
    @available_moves
  end
end

# Comprobar cuando comen, el peon, si es blanca o negra
#si se sale del tablero el moviemiento, podria ser que vaya a a entrar 
#por el otro extremo del tablero en el peon y rey y eso hay que arreglarlo tambien (dejar para el final la comparacion con si hay otra ficha, así podemos hacer que no pete???)


# my_pawn = Pawn.new
# my_king = King.new
# my_rook = Rook.new
my_bishop = Bishop.new


# g3 ---> 6,3
# c7 ---> 2,1
# f6 ---> 5,2
# h8 ---> 7,0
# d5 ---> 3,3
# b3 ---> 1,5
# b7 ---> 1,1
# f1 ---> 5,7



puts Position_translator.translate("b3")

puts  "-------"
# puts my_pawn.can_move_to(Position_translator.translate("g3"))
# puts my_king.can_move_to(Position_translator.translate("g3"))
# puts my_rook.can_move_to(Position_translator.translate("g3"))

puts my_bishop.can_move_to(Position_translator.translate("b3"))
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