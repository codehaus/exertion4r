require "exertion4r/modules/polar/polar_file"
require "exertion4r/modules/polar/polar_day_description"
require "exertion4r/modules/polar/polar_person_description"

class Polar
  def url=(url)
    @url = url
  end
  
  def open()
    @polar_file = PolarFile.new(@url)
    extension = @url[-4..-1]

    if extension == '.pdd'
      @pdd = PolarDayDescription.new(@polar_file)
      return @pdd
    end
    
    if extension == '.ppd'
      @ppd = PolarPersonDescription.new(@polar_file)
      return @ppd
    end
    
    puts "Unable to process file #{@polar_file} with extension #{extension}"
    
    return nil
  end
  
  def close()
    @polar_file = nil
    @polar_day_description = nil
  end
  
  def polar_file
    @polar_file
  end
  
  def polar_day_description
    @pdd
  end
  
  def polar_person_description
    @ppd
  end
  
end
