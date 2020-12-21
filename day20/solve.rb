#! /usr/bin/env ruby

module Solver
  Piece = Struct.new(:id, :pixels, :corner, :edge, :placed, :matching_pieces) do
    def edges 
      return [top, bottom, left, right]
    end

    def top
      return pixels[0]
    end

    def bottom
      return pixels.last
    end

    def left
      left, _, _ = _left_right_core
      left
    end

    def right
      _, right, _ = _left_right_core
      right
    end

    def core
      _, _, core = _left_right_core
      core
    end

    def flip_right_left
      (0...pixels.count).each do |row|
        pixels[row] = pixels[row].reverse
      end
    end

    def flip_top_bottom
      half = pixels.count / 2
      full = pixels.count - 1
      (0...half).each do |row|
        temp = pixels[row]
        pixels[row] = pixels[full - row]
        pixels[full - row] = temp
      end
    end

    def rotate_left
      lookup = Marshal.load(Marshal.dump(pixels))
      (0...pixels.count).each do |row|
        (0...pixels.count).each do |column|
          pixels[column][row] = lookup[row][(pixels.count - 1) - column]
        end
      end
    end

    private

    def _left_right_core
      left = ""
      right = ""
      core = []

      pixels.each_with_index do |line, index|
        left << line[0]
        right << line[-1]

        next if index == 0
        next if index == pixels.count - 1

        core << line[1..-2]
      end

      return left, right, core
    end
  end

  def self.read(file)
    tiles = {}

    File.read(file).split("\n\n").each do |t|
      lines = t.split("\n")

      tiles[lines[0].tr(":", "")] = lines[1..]
    end

    tiles
  end

  def self.parse_tiles(tiles)
    pieces = {}

    tiles.each do |key, value|

      left = ""
      right = ""
      core = []

      value.each_with_index do |line, index|
        left << line[0]
        right << line[-1]

        next if index == 0
        next if index == value.count - 1

        core << line[1..-2]
      end

      pieces[key] = Piece.new(key, value, false, false, nil)
      pieces[key].matching_pieces = []
    end

    pieces
  end

  def self.mark_corners_and_edges(pieces)
    corners = []

    pieces.each do |test_key, test_piece|
      match_count = 0

      pieces.each do |key, piece|
        next if test_piece.id == piece.id
      
        test_piece.edges.each do |test_edge|
          test_edge_flip = test_edge.reverse
          piece.edges.each do |edge|
            if edge == test_edge || edge == test_edge_flip
              match_count += 1 
              test_piece.matching_pieces << piece.id
            end
          end
        end
      end

      test_piece.corner = true if match_count == 2
      test_piece.edge = true if match_count == 3
      corners << test_piece.id if match_count == 2
    end

    corners
  end

  def self.solve_puzzle(pieces)
    dimension = Math.sqrt(pieces.count).to_i
    
    solution = Array.new(dimension) { Array.new(dimension) }

    corners = pieces.select {|k,v| v.corner }
    edges = pieces.select {|k,v| v.edge }

    solution[0][0] = corners.values.first
    solution[0][0].placed = true

    (0...dimension).each do |row|
      (0...dimension).each do |column|
        next if row == 0 and column == 0
        
        connectors = []
        connectors << solution[row-1][column] if row > 0
        connectors << solution[row][column-1] if column > 0

        possibles = []
        possibles += solution[row-1][column].matching_pieces if row > 0
        possibles += solution[row][column-1].matching_pieces if column > 0

        possibles.each do |possible|
          next if pieces[possible].placed
          next if row == 0 && (!pieces[possible].corner && !pieces[possible].edge)
          next if row == dimension - 1 && (!pieces[possible].corner && !pieces[possible].edge)
          next if column == 0 && (!pieces[possible].corner && !pieces[possible].edge)
          next if column == dimension - 1 && (!pieces[possible].corner && !pieces[possible].edge)

          connects = true
          connectors.each do |connection|
            connects == false if !connection.matching_pieces.include?(possible)
          end
          next if !connects

          solution[row][column] = pieces[possible]
          pieces[possible].placed = true
          break
        end
      end
    end

    solution
  end
  
  def self.align_top_left(solution, pieces)
    top_left = solution[0][0]

    right_piece = solution[0][1]
    bottom_piece = solution[1][0]

    match_right = false
    (0...4).each do |index|
      top_left.rotate_left unless index == 0

      right_piece.edges.each do |edge|
        flip_edge = edge.reverse
        match_right = true if top_left.right == edge || top_left.right == flip_edge
      end

      break if match_right 
    end

    raise if !match_right

    match_bottom = false
    (0...2).each do |index|
      top_left.flip_top_bottom unless index == 0

      bottom_piece.edges.each do |edge|
        flip_edge = edge.reverse
        match_bottom = true if top_left.bottom == edge || top_left.bottom == flip_edge
      end

      break if match_bottom 
    end

    raise if !match_bottom
  end

  def self.assemble_puzzle(solution, pieces)
    dimension = Math.sqrt(pieces.count).to_i

    (0...dimension).each do |row|
      if row != 0
        align_top_edge(solution[row][0], solution[row-1][0])
      end
      (0...dimension).each do |column|
        next if row == 0 and column == 0
        next if column == 0

        piece = solution[row][column]
        piece_to_left = solution[row][column-1]

        align_left_edge(piece, piece_to_left)
      end
    end
  end

  def self.align_left_edge(piece, piece_to_left)
    match_right = false
    (0...4).each do |index|
      piece.rotate_left unless index == 0

      match_right = true if piece_to_left.right == piece.left
      break if match_right 

      piece.flip_right_left
      match_right = true if piece_to_left.right == piece.left
      break if match_right 
      piece.flip_right_left
    end

    raise if !match_right
  end

  def self.align_top_edge(piece, piece_above)
    match_bottom = false

    (0...4).each do |index|
      piece.rotate_left unless index == 0

      match_bottom = true if piece_above.bottom == piece.top
      break if match_bottom

      piece.flip_right_left
      match_bottom = true if piece_above.bottom == piece.top
      break if match_bottom
      piece.flip_right_left
    end

    raise if !match_bottom
  end

  def self.assemble_image(solution)
    image = []
    
    count = 0
    solution.each_with_index do |row|
      (0...row[0].core.count).each do |index|
        image[count] = ""
        row.each do |cell|
          image[count] << cell.core[index]
        end
        count += 1
      end
    end

    image
  end
end

tiles = Solver.read("input.txt")
pieces = Solver.parse_tiles(tiles)
Solver.mark_corners_and_edges(pieces)

puts pieces.values.reduce(1) { |acc, piece| acc * (piece.corner ? piece.id[-4..-1].to_i : 1) }

solution = Solver.solve_puzzle(pieces)

Solver.align_top_left(solution, pieces)
Solver.assemble_puzzle(solution, pieces)
image = Solver.assemble_image(solution)

monster_body = /#....##....##....###/

count = 0
monster_count = 0

image.each do |line|
  count += line.count("#")
  monster_count +=  line.scan(monster_body).count
end
puts count - (monster_count * 15)