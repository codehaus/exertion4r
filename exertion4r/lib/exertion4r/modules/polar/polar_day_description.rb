require 'exertion4r/modules/polar/polar_file'
require 'exertion4r/modules/polar/polar_exercise_info'

class PolarDayDescription

  def initialize(polar_file)
    @polar_file = polar_file
    @exercise_infos = []
    
    
    ei_index = 1
    while true
      section = @polar_file.find_section_by_name("ExerciseInfo#{ei_index}")
      if section
        exercise_infos << PolarExerciseInfo.new(section)
      else 
        break
      end
      ei_index = ei_index + 1
    end
  end
  
  #Access to this should be avoided
  def polar_file
    @polar_file
  end
  
  def exercise_infos
    @exercise_infos
  end
  
  
end