class CalendarController < ApplicationController
  #attr_accessible :summary, :starttime, :timezone
  def index
    @calendars = Calendar.all
  end

  def import
    @uploaded_io = params[:file]
    
    if params[:file].blank?
      redirect_to '/calendar/index', :notice => "Please select a file to import."
    elsif @uploaded_io.content_type == "text/calendar"
      #puts("File Name: #{@uploaded_io.original_filename}")
      tmpfile=File.open(Rails.root.join('public', @uploaded_io.original_filename), 'wb') do |file|
        file.write(@uploaded_io.read)
      end
      redirect_to '/calendar/index', :notice => "Import successful."
      self.parse
    else
      redirect_to '/calendar/index', :notice => "Please select .ics file."
    end
  end

  def parse
    # Open a file or pass a string to the parser
    cal_file = File.open( Rails.root.join('public', @uploaded_io.original_filename), "r")
    # Parser returns an array of calendars because a single file
    # can have multiple calendars.
    cals = Icalendar.parse(cal_file)
    #puts("All Calendars: #{cals}")
    cals.each do |cal|
    # Now you can access the cal object in just the same way I created it
    # puts("Current Calendar: #{cal}")
      cal.events.each do |event|
        # puts "Current event : #{event}"
        @calendar = Calendar.new(params[:calendar])
        @calendar.assign_attributes(:summary => " #{event.summary}", :starttime => "#{event.dtstart}" , :timezone => "#{event.dtstart.ical_params['tzid']}")
        @calendar.save
      #puts "start date-time timezone: #{event.dtstart.ical_params['tzid']}"
      end
    end
  end

  def export
    calendar = Icalendar::Calendar.new
    events=Calendar.all

    events.each do |e|
      event = Icalendar::Event.new
      event.dtstart = e.starttime
      event.dtend = e.starttime#datetime.strftime("%Y%m%dT%H%M%S%Z")
      event.summary = e.summary
      calendar.add_event(event)
    #puts("Current Event: #{event}")
    end
    calendar.publish
    file = File.new("tmp/sample.ics", "w+")
    file.write(calendar.to_ical)
    file.close
    send_file("tmp/sample.ics")

  end

  private

  def calendar_params
    params.require(:calendar).permit(:summary, :starttime)
  end
end
