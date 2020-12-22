#! /usr/bin/env ruby
require "set"

module Combat
  def self.play(player1, player2)
    while true
      player1_card = player1.shift
      player2_card = player2.shift

      player1.push(player1_card, player2_card) if player1_card > player2_card
      player2.push(player2_card, player1_card) if player2_card > player1_card

      raise "No tie rule!" if player1_card == player2_card

      return player1 if player2.count == 0
      return player2 if player1.count == 0
    end
  end

  def self.score(player)
    score = 0
    player.reverse.each_with_index do |c, i|
      score += c * (i + 1)
    end
    score
  end
end

module RecursiveCombat
  def self.play(players, game_count, rounds)
    # puts "=== Game #{game_count} ==="
    round_count = 1
    while true
      # puts "-- Round #{round_count} (Game #{game_count}) --"
      return 0, players[0] if rounds.include?(players)

      round_count += 1
      rounds << [players[0].clone, players[1].clone]

      # pp players[0]
      # pp players[1]

      player1_card = players[0].shift
      player2_card = players[1].shift

      # puts "Player 1 plays: #{player1_card}"
      # puts "Player 2 plays: #{player2_card}"

      if player1_card <= players[0].count && player2_card <= players[1].count
        # puts "Playing a sub-game to determine the winner..."
        index, winner = RecursiveCombat.play([players[0][0...player1_card], players[1][0...player2_card]], game_count + 1, [])

        players[0].push(player1_card, player2_card) if index == 0
        players[1].push(player2_card, player1_card) if index == 1
      else
        raise "No tie rule!" if player1_card == player2_card
        
        players[0].push(player1_card, player2_card) if player1_card > player2_card
        players[1].push(player2_card, player1_card) if player2_card > player1_card
      end

      return 1, players[1] if players[0].count == 0
      return 0, players[0] if players[1].count == 0
    end
  end

  def self.score(player)
    score = 0
    player.reverse.each_with_index do |c, i|
      score += c * (i + 1)
    end
    score
  end
end

player1 = [26,8,2,17,19,29,41,7,25,33,50,16,36,37,32,4,46,12,21,48,11,6,13,23,9]
player2 = [27,47,15,45,10,14,3,44,31,39,42,5,49,24,22,20,30,1,35,38,18,43,28,40,34]

winner = Combat.play(player1.clone, player2.clone)
puts Combat.score(winner)

index, winner = RecursiveCombat.play([player1, player2], 1, [])
puts RecursiveCombat.score(winner)
