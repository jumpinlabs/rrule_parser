# RRuleParser

This gem allows you to parse RRULE expressions as defined in [RFC 2445](https://www.ietf.org/rfc/rfc2445.txt)

TODO:

- [x] Parsing RRULE format
- [x] Events with defined COUNT or UNTIL
- [x] Events with end
  - [x] Calculation of DAILY
  - [x] Calculation of interval start
  - [x] Calculation of interval end
  - [x] Calculation of WEEKLY with given set of DOWs
  - [x] Calculation of MONTHLY with given DAY number
  - [ ] Calculation of MONTHLY with given WEEKNO and DOW (e.g each second Monday)
  - [x] Calculation of YEARLY
- [ ] Get dates that fit into selected range
- [ ] Calculation of endless events
  - [ ] Setting calculation limit
  - [ ] Resume calculation after limit is reached
  - [ ] Get dates update: calculate necessary dates for the interval
- [ ] Exceptions list
- [ ] Documentation
- [ ] Convince jumpinlabs to open source it since it designed to assist
  calendar endpoints :love:
