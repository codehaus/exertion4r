require 'exertion4r/modules/polar/polar_file'
require 'exertion4r/modules/polar/polar_exercise_info'

class PolarDayDescription

  def initialize(polar_file)
    @polar_file = polar_file
    @exercise_infos = []
    
    ei_count = @polar_file.find_section_by_name("DayInfo").lines[1].fields[1].text.to_i
    
    1.upto(ei_count) { |ei_index|
      section = @polar_file.find_section_by_name("ExerciseInfo#{ei_index}")
      if section
        exercise_infos << PolarExerciseInfo.new(@polar_file, section)
      else 
        break
      end
    }
  end
  
  def date
    section = @polar_file.find_section_by_name('DayInfo')
    date = section.lines[1].fields[0].text
    Time.local(date[0..3], date[4..5], date[6..7], 0, 0, 0, 0)
  end
  
  #Access to this should be avoided
  def polar_file
    @polar_file
  end
  
  def exercise_infos
    @exercise_infos
  end
  
  def description
    section = dayinfo_section
    line_index = main_line_count + 1
    if section.lines.length > line_index
      section.lines[line_index].line
    else
      ""
    end
  end
  
private

  def dayinfo_section
    @polar_file.find_section_by_name('DayInfo')
  end
  
  #This is an internal polar file field that we use to calculate where the description / notes fields start
  def main_line_count
    dayinfo_section.lines[0].fields[2].text.to_i
  end

  
end