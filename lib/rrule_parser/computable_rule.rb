require 'active_support/all'

module RRuleParser
  class ComputableRule < Rule
    attr_accessor :start, :finish, :duration, :rule, :dates

    WEEKDAYS = {
      monday: 1,
      tuesday: 2,
      wednesday: 3,
      thursday: 4,
      friday: 5,
      saturday: 6,
      sunday: 7
    }

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

    # this fills in @dates array with dates that match this rrule
    def calc_dates
      @dates = []
      if freq == :weeks
        calc_week(@start)
      else
        calc_normal(@start)
      end
    end

    def calc_week(start)
      dows = by_day.map do |d|
        WEEKDAYS[d]
      end.sort
      @current_date = start
      ix = dows.index(start.wday) || 0

      begin
        puts @current_date
        @dates << @current_date

        prev_dow = dows[ix]
        ix += 1
        if ix >= dows.size
          ix = 0
          @current_date = @current_date.advance(:weeks => (interval - 1))
        end
        dow = dows[ix]
        diff = dow - prev_dow
        diff += 7 if diff <= 0
        @current_date = @current_date.advance(:days => diff)
      end while calc_stop_condition
    end

    def calc_normal(start)
      @current_date = start
      begin
        @dates << @current_date
        @current_date = @current_date.advance(freq => interval)
      end while calc_stop_condition
    end

    def calc_stop_condition
      if count
        @dates.size != count
      elsif self.until
        @current_date < self.until
      end
    end
  end
end
