require "rrule_parser/version"
require "rrule_parser/rule"
require "rrule_parser/computable_rule"

module RRuleParser
  def self.parse(start_time, end_time, string, max=1000)
    ComputableRule.new(start_time, end_time, string, max)
  end
end
