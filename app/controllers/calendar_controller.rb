class CalendarController < ApplicationController
  #attr_accessible :summary, :starttime
  def index
    @calendars = Calendar.all
  end

  def show
    @calendars = Calendar.all
    # Open a file or pass a string to the parser
    cal_file = File.open("ashoka.p@gmail.com.ics", "r")

    # Parser returns an array of calendars because a single file
    # can have multiple calendars.
    cals = Icalendar.parse(cal_file)
    puts("All Calendars: #{cals}")
    #cal = cals.first
    i=0
    j=0
    cals.each do |cal|
    # Now you can access the cal object in just the same way I created it
      puts("Current Calendar: #{cal}")
      cal.events.each do |event|
        puts "Current event : #{event}"
        i+=1
        @calendar = Calendar.new(params[:calendar])
        @calendar.assign_attributes(:summary => " #{event.summary}", :starttime => "#{event.dtstart}" )
        @calendar.save
        puts "start date-time timezone: #{event.dtstart.ical_params['tzid']}"
        
      end
      j+=1

    end
    puts "Counters: i #{i}, j #{j}"
  #@calendar = Calendar.find(params[:id])
  end

  private

  def calendar_params
    params.require(:calendar).permit(:summary, :starttime)
  end
end
