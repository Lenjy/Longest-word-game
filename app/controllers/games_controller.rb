  
require 'open-uri'

class GamesController < ApplicationController
  def new
    @letters = []
    10.times do
      @letters << ("A".."Z").to_a.sample
    end
  end
  
  def score
    # instanciation des variables nécéssaires
    end_time   = Time.now
    start_time = params[:start_time]
    @word      = params[:word].upcase
    word_array = @word.chars
    @letters   = params[:letters]

    # Check si le mot est composé des lettres proposées 
    valid_word = word_array.all? do |char|
      @letters.count(char) >= word_array.count(char)
    end

    if valid_word
      # preparation du lien API
      url = "https://wagon-dictionary.herokuapp.com/#{@word}"
      dictionary = open(url).read

      # check si le mot existe
      result = JSON.parse(dictionary)

      if result["found"]
        @message = "I never thought i would say that, but you won..."
        # utilisation du temps écoulé
        time_multiplier = (end_time - start_time.to_time) / 60
        # calcul du score
        @score = @word.length / time_multiplier
      else
        # si le mot n'existe pas
        @message = "That word doesn't exist, are you that stupid ?"
      end
    else
      # si le message est formé avec des mauvaise lettres
      @message = "your word can't be formed with that grid. are you blind?"
    end

    @score ||= 0
  
  end
  
end
