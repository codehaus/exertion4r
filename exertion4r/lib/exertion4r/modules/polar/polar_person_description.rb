require 'exertion4r/modules/polar/polar_file'
require 'exertion4r/modules/polar/polar_exercise_info'

class PolarPersonDescription

  def initialize(polar_file)
    @polar_file = polar_file
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
  
  
  def first_name
    section = @polar_file.find_section_by_name('PersonInfo')
    return section.lines[7].line
  end
  
  def last_name
    section = @polar_file.find_section_by_name('PersonInfo')
    return section.lines[8].line
  end

end