require 'minitest/autorun'
require 'minitest/pride'
require './multilinguist.rb'

class TestMultilinguist < MiniTest::Test

  def setup
    @speaker = Multilinguist.new

  end
  def test_language_in_no_country
    assert_equal("NA", @speaker.language_in(""))
  end

  def test_language_in_appropriate_country
    assert_equal("hi",@speaker.language_in("india"))
  end
end
