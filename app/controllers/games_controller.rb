require "json"
require "open-uri"

class GamesController < ApplicationController
  def new
    @letters = ('A'..'Z').to_a.sample(10);
  end

  def score
    @user_input = params[:word]
    @letters = params[:letters]
    @score = @user_input.length

    if word_in_grid?(@user_input)
      if valid_english_word?
        @score = @user_input.length
        @result = "Congratulations!#{@user_input} is a valid English word!"
      else
        @result = "Sorry but #{@user_input} does not seem to be a valid English word..."
      end
    else
      @result = "Sorry but #{@user_input} can't be built out of #{@letters}"
    end
  end

  # The word can't be built out of the original grid (@letters)
  def word_in_grid?(word)
    word.chars.all? { |char| word.count(char) <= @letters.count(char) }
  end

  # The word is valid according to the grid (@letters), but it is not a valid English word
  # The word is valid according to the grid (@letters) and is an English word
  def valid_english_word?
    url = "https://dictionary.lewagon.com/#{@user_input}"
    response = URI.parse(url).read
    JSON.parse(response)["found"]
  end
end
