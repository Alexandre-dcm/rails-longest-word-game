require 'open-uri'
require 'json'

class GamesController < ApplicationController

  def new
    @letters = grid
  end

  def score
    @included = included?(params[:letters])
    @english_word = english_word?
    @feedback = ""
    if @included == false
      @feedback = "Your word is not in the grid !"
      @score = 0
    elsif @english_word == false
      @feedback = "Your word is not an english word"
      @score = 0
    else
      @feedback = "Congratulations !"
      @score = params[:typebar].length
    end
  end

  private

  def grid
    alphabet = ('a'..'z').to_a
    letters = []
    10.times do
      letters << alphabet[rand(25)]
    end
    letters
  end

  def included?(letters)
    guess = params[:typebar]
    guess.chars.all? { |letter| guess.count(letter) <= letters.count(letter) }
  end

  def english_word?
    guess = params[:typebar]
    response = URI.open("https://wagon-dictionary.herokuapp.com/#{guess}")
    json = JSON.parse(response.read)
    return json['found']
  end

end
