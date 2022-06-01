require "test_helper"

class JobTest < ActiveSupport::TestCase
  test "the truth" do
    assert true
  end

  test "pct_format" do
    assert_equal(Job.pct_format(0.53), 53)
  end
end
