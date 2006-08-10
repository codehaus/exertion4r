#The PolarFile class provides a low level API for loading a Polar style text file
#It does not perform any conversion / higher level functions. Clients
#should instead use the PolarDayDescription class
class PolarFile
  attr_reader :filename
  
  def initialize(filename)
    sections = []
    @filename = filename
    open(filename) { |io|
    
      section_name = nil
      section_lines = []
      
      io.each_line { |line|
        line.strip!
        
        
        if line == ''
          #puts "blanky #{section_name}"
          if section_name
            sections << PolarSection.new(self, section_name, section_lines)
            section_name = nil
            section_lines = []
          end
          next
        end
        
        if line[0..0] == '['
          section_name = line[1..-2]
          section_lines = []
          next
        end
        
        section_lines << PolarLine.new(line)
        
      }
    }
    @sections = sections
  end
  
  def sections 
    @sections
  end
  
  def find_section_by_name(name)
    sections.each { | section | 
      return section if section.name == name
    }
    nil
  end
  
end


class PolarSection
  attr_reader :polar_file
  
  def initialize(polar_file, name, lines)
    @polar_file = polar_file
    @name = name
    @lines = lines
  end
  
  def name()
    @name
  end
  
  def lines()
    @lines
  end
  
  def find_property_value_by_name(property_name)
    re = Regexp.new("^#{property_name}=(.*)$")
    lines.each { |line|
      if line.line =~ re
        return $1
      end
    }
    nil
  end

end

class PolarLine
  def initialize(line)
    @line = line
  end
  
  def line()
    @line
  end
  
  def fields()
    fields = []
    @line.split().each { |field|
      fields << PolarField.new(field)
    }
    return fields
  end
  
  def to_s
    "PolarLine[#{@line}]"
  end

end

class PolarField
  def initialize(text)
    @text = text
  end
  
  def text
    @text
  end
end