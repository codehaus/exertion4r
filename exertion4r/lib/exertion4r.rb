  
class Exertion4r

  def initialize(module_name, url)
    
    require "exertion4r/modules/#{module_name.downcase}/#{module_name.downcase}"
    cmd = "#{module_name}.new"
    @driver = eval(cmd)
    @driver.url = url
  end
  
  def run()
    puts "goober"
  
  end
  
  def open()
    @driver.open()
  end
  
  def driver
    @driver
  end

end