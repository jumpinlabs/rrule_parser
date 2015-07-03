module RRuleParser
  class Rule
    attr_accessor :freq, :until, :interval, :count, :by_day

    DAY_MAP = {
      "MO" => :monday,
      "TU" => :tuesday,
      "WE" => :wednesday,
      "TH" => :thursday,
      "FR" => :friday,
      "SA" => :saturday,
      "SU" => :sunday
    }
    
    def initialize(rule)
      @rule = rule
      parse_rule
      parse_freq
      parse_count
      parse_until
      parse_interval
      parse_by_day
    end

    def is_endless?
      !(@until || @count)
    end

    protected

    def parse_rule
      _, list_def = @rule.split(':')
      rules_list = list_def.split(';')
      @parsed_rule = {}
      rules_list.each do |r|
        key, val = r.split('=')
        @parsed_rule[key] = val
      end
    end

    def parse_freq
      @freq = case @parsed_rule["FREQ"]
      when "DAILY"
        :days
      when "WEEKLY"
        :weeks
      when "MONTHLY"
        :months
      when "YEARLY"
        :years
      end
    end

    def parse_count
      @count = @parsed_rule["COUNT"].to_i if @parsed_rule["COUNT"]
    end

    def parse_until
      if @parsed_rule["UNTIL"]
        @until = Time.parse(@parsed_rule["UNTIL"])
      end
    end

    def parse_interval
      if @parsed_rule["INTERVAL"]
        @interval = @parsed_rule["INTERVAL"].to_i
      else
        @interval = 1
      end
    end

    def parse_by_day
      if @parsed_rule["BYDAY"]
        @by_day = []
        @parsed_rule["BYDAY"].split(",").each do |day|
          d = DAY_MAP[day]
          if d
            @by_day << d
          else
            puts "WARN: by weekday of month is not supported yet"
          end
        end
      end
    end
  end
end
