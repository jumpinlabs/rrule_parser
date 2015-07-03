require 'spec_helper'
require 'active_support/all'

describe RRuleParser::ComputableRule do
  it "calculates duration" do
    t1 = Time.now
    t2 = Time.now + 2.hours
    rule = RRuleParser::ComputableRule.new(t1, t2, "RRULE:FREQ=DAILY;COUNT=1")
    expect(rule.duration).to eq(t2-t1)
  end

  describe "calculations for Tue, June 2, 2015" do
    # June 2015 has 4 weeks and June 1, 2015 is Monday. That's convinient
    # We start everything on Tue, June 2 2015
    let (:start)  { Time.parse("2015-06-02T03:00:00+03:00") }
    let (:finish) { Time.parse("2015-06-02T04:00:00+03:00") }
    let (:rule)   { RRuleParser::ComputableRule.new(start, finish, expr) }

    describe "DAILY" do
      describe "with 4 occurrencies" do
        let (:expr)   { "RRULE:FREQ=DAILY;COUNT=4" }

        it "will produce 4 occurrencies" do
          expect(rule.dates.count).to eq(4)
        end

        it "first date will be Tue, Jun 2" do
          expect(rule.start.to_date).to eq(Date.new(2015, 6, 2))
        end

        it "last date will be Fri, Jun 5" do
          expect(rule.end.to_date).to eq(Date.new(2015, 6, 5))
        end
      end

      describe "until Sunday" do
        let (:expr)   { "RRULE:FREQ=DAILY;UNTIL=20150607T120000Z" }

        it "will produce 6 occurrencies" do
          expect(rule.dates.count).to eq(6)
        end

        it "first date will be Tue, Jun 2" do
          expect(rule.start.to_date).to eq(Date.new(2015, 6, 2))
        end

        it "last date will be Sun, Jun 7" do
          expect(rule.end.to_date).to eq(Date.new(2015, 6, 7))
        end
      end

      describe "each 2 days with 4 occurrencies" do
        let (:expr)   { "RRULE:FREQ=DAILY;INTERVAL=2;COUNT=4" }

        it "will produce 4 occurrencies" do
          expect(rule.dates.count).to eq(4)
        end

        it "first date will be Tue, Jun 2" do
          expect(rule.start.to_date).to eq(Date.new(2015, 6, 2))
        end

        it "last date will be Tue, Jun 8" do
          expect(rule.end.to_date).to eq(Date.new(2015, 6, 8))
        end
      end

      describe "each 2 days until sunday" do
        let (:expr)   { "RRULE:FREQ=DAILY;INTERVAL=2;UNTIL=20150607T120000Z" }

        it "will produce 3 occurrencies" do
          expect(rule.dates.count).to eq(3)
        end

        it "first date will be Tue, Jun 2" do
          expect(rule.start.to_date).to eq(Date.new(2015, 6, 2))
        end

        it "last date will be Sat, Jun 6" do
          expect(rule.end.to_date).to eq(Date.new(2015, 6, 6))
        end
      end
    end

    describe "WEEKLY" do
      describe "every Tuesday with 4 occurrencies" do
        let (:expr) { "RRULE:FREQ=WEEKLY;COUNT=4;BYDAY=TU" }

        it "will produce 4 occurrencies" do
          expect(rule.dates.count).to eq(4)
        end

        it "first date will be Tue, Jun 2" do
          expect(rule.start.to_date).to eq(Date.new(2015, 6, 2))
        end

        it "last date will be Tue, Jun 23" do
          expect(rule.end.to_date).to eq(Date.new(2015, 6, 23))
        end
      end

      describe "every Tuesday and Friday with 4 occurrencies" do
        let (:expr) { "RRULE:FREQ=WEEKLY;COUNT=4;BYDAY=TU,FR" }

        it "will produce 4 occurrencies" do
          expect(rule.dates.count).to eq(4)
          puts rule.dates
        end

        it "first date will be Tue, Jun 2" do
          expect(rule.start.to_date).to eq(Date.new(2015, 6, 2))
        end

        it "last date will be Fri, Jun 12" do
          expect(rule.end.to_date).to eq(Date.new(2015, 6, 12))
        end
      end

      describe "every Tuesday with interval of 2 weeks and 3 occurrencies" do
        let (:expr) { "RRULE:FREQ=WEEKLY;COUNT=3;INTERVAL=2;BYDAY=TU" }

        it "will produce 3 occurrencies" do
          expect(rule.dates.count).to eq(3)
          puts rule.dates
        end

        it "first date will be Tue, Jun 2" do
          expect(rule.start.to_date).to eq(Date.new(2015, 6, 2))
        end

        it "last date will be Fri, Jun 30" do
          expect(rule.end.to_date).to eq(Date.new(2015, 6, 30))
        end
      end
    end
  end
end
