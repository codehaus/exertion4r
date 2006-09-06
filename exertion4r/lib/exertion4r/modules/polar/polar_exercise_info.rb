require 'exertion4r/modules/polar/polar_exercise_datapoint'

class PolarExerciseInfo
  
  def initialize(pdd_polar_file, section)
    @pdd_polar_file = pdd_polar_file
    @pdd_section = section
    
    hrm_line_index = main_line_count + 3
    if section.lines.length > hrm_line_index
      hrm_file = section.lines[hrm_line_index].line
      hrm_file = hrm_file.gsub('\\', '/')
      hrm_file = File.basename(hrm_file)
      @polar_file = PolarFile.new(File.dirname(section.polar_file.filename) + "/" + hrm_file)
    else
      #puts "not enough lines : #{description}"
      #index = 0
      #section.lines.each { |line| 
      #  puts "#{index}: #{line}"
      #  index = index + 1
      #}
    end
  end
  
  
  def description
    line_index = main_line_count + 1
    if @pdd_section.lines.length > line_index
      @pdd_section.lines[line_index].line
    else
      ""
    end
  end
  
  def notes
    line_index = main_line_count + 2
    if @pdd_section.lines.length > line_index
      @pdd_section.lines[line_index].line
    else
      nil
    end
  end
  
  #Computed from start_time and date
  def start_date_time
    #Date=20060730
    #StartTime=09:35:47.0
    Time.local(date[0..3], date[4..5], date[6..7], start_time[0..1], start_time[3..4], start_time[6..7], start_time[9..9] * 100)
  end

  
    
  
  def version
    params_section().find_property_value_by_name("Version")
  end
  
  def start_time
    #HRM files are not used unless you have recorded data. If you are manually creating events, you just use it from the PDD file
    #data will be something like 43200 - for 12:00pm
    secs = @pdd_section.lines[1].fields[4].text.to_i
    
    hours = (secs / 3600).truncate
    secs = secs - hours * 3600
    minutes = (secs / 60).truncate
    secs = secs - minutes * 60
    return sprintf("%02d:%02d:%02d.0", hours, minutes, secs)
    
    #If you have an HRM file, you can get it from here
    #params_section().find_property_value_by_name("StartTime")
  end

  def interval
    params_section().find_property_value_by_name("Interval").to_i
  end
  
  def length
    # length looks something like X:XX:XX.X
    length = params_section().find_property_value_by_name("Length")
    pieces = length.split(':')
    
    return pieces[0].to_i * 3600 + pieces[1].to_i * 60 + pieces[2].to_f
  end
  
  def date
    dayinfo = @pdd_polar_file.find_section_by_name("DayInfo")
    return dayinfo.lines[1].fields[0].text
    #If you have an HRM file, you can get it from here
    #params_section().find_property_value_by_name("Date")
  end

  def weight
    params_section().find_property_value_by_name("Weight").to_f
  end

  def max_hr
    params_section().find_property_value_by_name("MaxHR").to_i
  end

  def rest_hr
    params_section().find_property_value_by_name("RestHR").to_i
  end

  def smode
    params_section().find_property_value_by_name("SMode")
  end
  
  def smode_char(i)
    smode()[i..i]
  end

  def smode_speed
    smode_char(0) != '0'
  end
  
  def smode_cadence
    smode_char(1) != '0'
  end
  
  def smode_altitude
    smode_char(2) != '0'
  end

  def smode_power
    smode_char(3) != '0'
  end

  def smode_power_left_right_balance
    smode_char(4) != '0'
  end

  def smode_power_pedalling_index
    smode_char(5) != '0'
  end

  def smode_hr_cc_data
    smode_char(6) != '0'
  end

  def smode_imperial_units
    smode_char(7) != '0'
  end

  def smode_air_pressure
    smode_char(8) != '0'
  end
  
  def datapoints
    section = @polar_file.find_section_by_name("HRData")
    points = []
    section.lines.each { |line|
      elements = []
      line.fields.each { |field|
        elements << field.text
      }
      points << PolarExerciseDatapoint.new(elements)
    }
    points
  end
  
  def hr_element_index()
    return 0
  end
  
  def speed_element_index()
    return -1 unless smode_speed
    hr_element_index + 1
  end
  
  def cadence_element_index()
    return -1 unless smode_cadence
    hr_element_index + (smode_speed ? 1 : 0) + 1
  end
  
  def altitude_element_index()
    return -1 unless smode_altitude
    hr_element_index + (smode_speed ? 1 : 0) + (smode_cadence ? 1 : 0) + 1
  end

  def power_element_index()
    return -1 unless smode_power
    hr_element_index + (smode_speed ? 1 : 0) + (smode_cadence ? 1 : 0) + (smode_altitude ? 1 : 0) + 1
  end

  def power_lrbpi_element_index()
    return -1 unless smode_power_left_right_balance and smode_power_pedalling_index
    hr_element_index + (smode_speed ? 1 : 0) + (smode_cadence ? 1 : 0) + (smode_altitude ? 1 : 0) + (smode_power ? 1 : 0) + 1
  end

private
  def params_section()
    @polar_file.find_section_by_name("Params")
  end
  
  #This is an internal polar file field that we use to calculate where the description / notes fields start
  def main_line_count
    @pdd_section.lines[0].fields[2].text.to_i
  end
  
end