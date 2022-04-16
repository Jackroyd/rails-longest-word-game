class GamesController < ApplicationController
  def new
    @letters = []
    10.times do
      @letters << ('a'..'z').to_a.sample.upcase
    end
    @start_time = Process.clock_gettime(Process::CLOCK_MONOTONIC)
  end

  def score
    require 'json'
    require 'open-uri'
    letters = params[:letters].chars
    word = params[:word]
    @end_time = Process.clock_gettime(Process::CLOCK_MONOTONIC)
    time_taken = @end_time.to_i - params[:start_time].to_i

    url = "https://wagon-dictionary.herokuapp.com/#{word}"
    data_serialized = URI.open(url).read
    data = JSON.parse(data_serialized)
    real_word = data["found"]
    correct_letters = true

    word.downcase.chars.each do |l|
      if letters.include?(l)
        letters.delete_at(letters.find_index(l))
      else
        correct_letters = false
        break
      end
    end

    if real_word && correct_letters
      @score = "Well done! You made a valid #{word.length} letter word in #{time_taken} seconds"
    elsif real_word && !correct_letters
      @score = "Incorrect! You didn't use the correct letters"
    elsif !real_word && correct_letters
      @score = "Incorrect! That word isn't real"
    else
      @score = 'You gone done fucked up'
    end
  end
end
