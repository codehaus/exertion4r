require "exertion4r/modules/polar/polar_file"
require "exertion4r/modules/polar/polar_day_description"

class Polar
  def url=(url)
    @url = url
  end
  
  def open()
    @polar_file = PolarFile.new(@url)
    @polar_day_description = PolarDayDescription.new(@polar_file)
    @polar_day_description
  end
  
  def close()
    @polar_file = nil
    @polar_day_description = nil
  end
  
  def polar_file
    @polar_file
  end
  
  def polar_day_description
    @polar_day_description
  end
  
end
