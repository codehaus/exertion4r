require 'exertion4r/modules/polar/polar_exercise_datapoint'

class PolarExerciseInfo
  
  def initialize(section)
    @polar_file = PolarFile.new(File.dirname(section.polar_file.filename) + "/" + section.lines.last.line)
  end
  
  def version
    params_section().find_property_value_by_name("Version")
  end
  
  def start_time
    params_section().find_property_value_by_name("StartTime")
  end

  def interval
    params_section().find_property_value_by_name("Interval")
  end
  
  def length
    params_section().find_property_value_by_name("Length")
  end
  
  def date
    params_section().find_property_value_by_name("Date")
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
  
end