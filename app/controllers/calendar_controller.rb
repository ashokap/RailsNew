class CalendarController < ApplicationController
  #attr_accessible :summary, :starttime, :timezone
  def index
    @calendars = Calendar.all
  end

  def import
    #@calendars = Calendar.all
    @uploaded_io = params[:file]
    if params[:file].blank?
     # render action: 'index', notice: 'Please select a file to import.'
      flash.now[:notice] = "Saved!"
    #redirect_to :back
      #flash[:error] = 'Please select a file to import.'
    else
    #puts("File Name: #{@uploaded_io.original_filename}")
      tmpfile=File.open(Rails.root.join('public', @uploaded_io.original_filename), 'wb') do |file|
        file.write(@uploaded_io.read)
      end
      flash[:notice] = "Import successful"
    self.parse
    end

    redirect_to '/calendar/index'
  end

  def parse

    puts("Uploaded file name: #{@uploaded_io.original_filename}")
    #@calendars = Calendar.all
    # Open a file or pass a string to the parser
    cal_file = File.open( Rails.root.join('public', @uploaded_io.original_filename), "r")

    # Parser returns an array of calendars because a single file
    # can have multiple calendars.
    cals = Icalendar.parse(cal_file)
    #puts("All Calendars: #{cals}")

    i=0
    j=0
    cals.each do |cal|
    # Now you can access the cal object in just the same way I created it
    # puts("Current Calendar: #{cal}")
      cal.events.each do |event|
        i+=1
        # puts "Current event : #{event}"

        @calendar = Calendar.new(params[:calendar])
        @calendar.assign_attributes(:summary => " #{event.summary}", :starttime => "#{event.dtstart}" , :timezone => "#{event.dtstart.ical_params['tzid']}")
        @calendar.save
      #puts "start date-time timezone: #{event.dtstart.ical_params['tzid']}"

      end
      j+=1
    end
  #puts "Counters: i #{i}, j #{j}"

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
