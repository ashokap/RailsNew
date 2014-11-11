class CalendarController < ApplicationController
  def show
    # Open a file or pass a string to the parser
cal_file = File.open("basic.ics", "r")

# Parser returns an array of calendars because a single file
# can have multiple calendars.
cals = Icalendar.parse(cal_file)
cal = cals.first

# Now you can access the cal object in just the same way I created it
event = cal.events.first
@calendar="#(event.dtstart)"
puts "start date-time: #{event.dtstart}"
puts "start date-time timezone: #{event.dtstart.ical_params['tzid']}"
puts "summary: #{event.summary}"

  end
end
