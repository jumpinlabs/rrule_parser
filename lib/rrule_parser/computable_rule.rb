require 'active_support/all'

module RRuleParser
  class ComputableRule < Rule
    attr_accessor :start, :finish, :duration, :rule, :dates

    def initialize(start, finish, rule)
      super(rule)
      @start = start
      @finish = finish
      @duration = finish - start
      calc_dates unless is_endless?
    end

    def start
      (@dates ? @dates.first : @start) + duration
    end

    def end
      @dates.try(:last)
    end

    protected

    def calc_dates
      @dates = []
      cur = @start
      begin
        @dates << cur
        cur += interval.send(freq)
      end while calc_condition(cur)
    end

    def calc_condition(cur)
      if count
        @dates.size != count
      elsif self.until
        cur < self.until
      end
    end
  end
end
