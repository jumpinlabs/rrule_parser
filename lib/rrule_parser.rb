require "rrule_parser/version"
require "rrule_parser/rule"

module RRuleParser
  def self.parse(start_time, end_time, string)
    Rule.new(start_time, end_time, string)
  end
end
