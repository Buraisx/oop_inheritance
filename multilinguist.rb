require 'httparty'
require 'json'


# This class represents a world traveller who knows what languages are spoken in each country
# around the world and can cobble together a sentence in most of them (but not very well)
class Multilinguist

  TRANSLTR_BASE_URL = "http://bitmakertranslate.herokuapp.com"
  COUNTRIES_BASE_URL = "https://restcountries.eu/rest/v2/name"
  #{name}?fullText=true
  #?text=The%20total%20is%2020485&to=ja&from=en


  # Initializes the multilinguist's @current_lang to 'en'
  #
  # @return [Multilinguist] A new instance of Multilinguist
  def initialize
    @current_lang = 'en'
  end
  def not_found
      {"status":404,"message":"Not Found"}
  end
  # Uses the RestCountries API to look up one of the languages
  # spoken in a given country
  #
  # @param country_name [String] The full name of a country
  # @return [String] A 2 letter iso639_1 language code
  def language_in(country_name)

      params = {query: {fullText: 'true'}}
      response = HTTParty.get("#{COUNTRIES_BASE_URL}/#{country_name}", params)
    if !country_name.empty?
      json_response = JSON.parse(response.body)
      json_response.first['languages'].first['iso639_1']
    else
      return "NA"
    end
  end

  # Sets @current_lang to one of the languages spoken
  # in a given country
  #
  # @param country_name [String] The full name of a country
  # @return [String] The new value of @current_lang as a 2 letter iso639_1 code
  def travel_to(country_name)
    local_lang = language_in(country_name)
    @current_lang = local_lang
  end

  # (Roughly) translates msg into @current_lang using the Transltr API
  #
  # @param msg [String] A message to be translated
  # @return [String] A rough translation of msg
  def say_in_local_language(msg)
    params = {query: {text: msg, to: @current_lang, from: 'en'}}
    response = HTTParty.get(TRANSLTR_BASE_URL, params)
    json_response = JSON.parse(response.body)
    json_response['translationText']
  end
end

class MathGenius < Multilinguist
    def report_total(array_nums)
      sum = 0
      array_nums.each do |numbers|
        sum += numbers
      end
      return say_in_local_language("The total is #{sum}")
    end
end

class QuoteCollector < Multilinguist
  def initialize
    @quote_collection = []
  end

  def add_quote(quote)
    @quote_collection << quote
  end

  def unleash_quote
    return say_in_local_language(@quote_collection.sample)
  end
end

# me = MathGenius.new
# puts me.report_total([23,45,676,34,5778,4,23,5465]) # The total is 12048
# me.travel_to("India")
# puts me.report_total([6,3,6,68,455,4,467,57,4,534]) # है को कुल 1604
# me.travel_to("Italy")
# puts me.report_total([324,245,6,343647,686545]) # È Il totale 1030767
#
# me2 = QuoteCollector.new
# me2.add_quote("90 percent of facts on the internet are true - Genghis Khan")
# me2.add_quote("Fly you fools - Dumbledore")
# me2.add_quote("Why don't you take a seat over here? - Chris Handsome")
# puts me2.unleash_quote
# me2.travel_to("Japan")
# puts me2.unleash_quote
# me2.travel_to("Spain")
# puts me2.unleash_quote
