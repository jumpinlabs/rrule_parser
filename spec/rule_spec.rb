require 'spec_helper'

describe RRuleParser::Rule do
  describe "format parsing" do
    describe "FREQ parsing" do
      it "parses FREQ=DAILY;" do
        rule = RRuleParser::Rule.new("RRULE:FREQ=DAILY;COUNT=5")
        expect(rule.freq).to eq(:day)
      end

      it "parses FREQ=WEEKLY;" do
        rule = RRuleParser::Rule.new("RRULE:FREQ=WEEKLY;COUNT=5")
        expect(rule.freq).to eq(:week)
      end

      it "parses FREQ=MONTHLY;" do
        rule = RRuleParser::Rule.new("RRULE:FREQ=MONTHLY;COUNT=5")
        expect(rule.freq).to eq(:month)
      end

      it "parses FREQ=YEARLY;" do
        rule = RRuleParser::Rule.new("RRULE:FREQ=YEARLY;COUNT=5")
        expect(rule.freq).to eq(:year)
      end
    end

    describe "COUNT parsing" do
      it "parses COUNT=1;" do
        rule = RRuleParser::Rule.new("RRULE:FREQ=DAILY;COUNT=1")
        expect(rule.count).to eq(1)
      end

      it "parses COUNT=30;" do
        rule = RRuleParser::Rule.new("RRULE:FREQ=DAILY;COUNT=30")
        expect(rule.count).to eq(30)
      end

      it "parses nothing if not specified" do
        rule = RRuleParser::Rule.new("RRULE:FREQ=DAILY")
        expect(rule.count).to be_nil
      end
    end

    describe "UNTIL parsing" do
      it "parses time" do
        rule = RRuleParser::Rule.new("RRULE:FREQ=DAILY;UNTIL=20160101T080000Z")
        expect(rule.until).to eq(Time.new(2016, 1, 1, 8, 0, 0, +00))
      end

      it "parses nothing if not specified" do
        rule = RRuleParser::Rule.new("RRULE:FREQ=DAILY")
        expect(rule.until).to be_nil
      end
    end

    describe "INTERVAL parsing" do
      it "parses INTERVAL=2" do
        rule = RRuleParser::Rule.new("RRULE:FREQ=DAILY;INTERVAL=2")
        expect(rule.interval).to eq(2)
      end

      it "parses 1 as interval if interval is not specified" do
        rule = RRuleParser::Rule.new("RRULE:FREQ=DAILY")
        expect(rule.interval).to eq(1)
      end
    end

    describe "BYDAY parsing" do
      it "parses days when I hit the gym" do
        rule = RRuleParser::Rule.new("RRULE:FREQ=WEEKLY;BYDAY=MO,WE,FR")
        expect(rule.by_day).to eq([:monday, :wednesday, :friday])
      end

      it "parses days when eat shit" do
        rule = RRuleParser::Rule.new("RRULE:FREQ=WEEKLY;BYDAY=TU,TH")
        expect(rule.by_day).to eq([:tuesday, :thursday])
      end

      it "parses weekends" do
        rule = RRuleParser::Rule.new("RRULE:FREQ=WEEKLY;BYDAY=SA,SU")
        expect(rule.by_day).to eq([:saturday, :sunday])
      end

      it "parses mondays" do
        rule = RRuleParser::Rule.new("RRULE:FREQ=WEEKLY;BYDAY=MO")
        expect(rule.by_day).to eq([:monday])
      end
    end
  end

  describe "other properties" do
    describe "#is_endless?" do
      it "is true if COUNT given" do
        rule = RRuleParser::Rule.new("RRULE:FREQ=WEEKLY;COUNT=10")
        expect(rule.is_endless?).to be_true
      end

      it "is true if UNTIL given" do
        rule = RRuleParser::Rule.new("RRULE:FREQ=WEEKLY;UNTIL=20160101T080000Z")
        expect(rule.is_endless?).to be_true
      end

      it "is false otherwise" do
        rule = RRuleParser::Rule.new("RRULE:FREQ=WEEKLY;BYDAY=SA,SU")
        expect(rule.is_endless?).to be_false
      end
    end
  end
end
