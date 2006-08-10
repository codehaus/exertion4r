$: << './lib'

require 'test/unit'
require 'exertion4r'

class PolarTest < Test::Unit::TestCase

  def test_basic()
    #e = Exertion4::Modules::Polar::Polar.new
    exertion = Exertion4r.new('Polar', "./test/20060730.pdd")
    exertion.open
    
    polar_file = exertion.driver.polar_file 
    polar_day_description = exertion.driver.polar_day_description
    
    assert_equal 3, polar_file.sections.length
    
    dayinfo = polar_file.sections.first
    
    
    assert_equal "DayInfo", dayinfo.name
    assert_equal 8, dayinfo.lines.length
    assert_equal "100	1	7	6	1	256",             dayinfo.lines[0].line
    assert_equal "20060730	2	60	0	10100	18000",   dayinfo.lines[1].line
    assert_equal "3	0	0	0	0	0",                   dayinfo.lines[2].line
    assert_equal "0	0	0	0	0	0",                   dayinfo.lines[3].line
    assert_equal "0	0	0	0	260	0",                   dayinfo.lines[4].line
    assert_equal "0	0	0	0	0	0",                   dayinfo.lines[5].line
    assert_equal "0	0	0	0	0	0",                   dayinfo.lines[6].line
    assert_equal "0	0	0	0	0	0",                   dayinfo.lines[7].line

    exe1 = polar_file.sections[1]
    assert_equal "ExerciseInfo1", exe1.name
    assert_equal 23, exe1.lines.length
    assert_equal "Coomera Half Iron course", exe1.lines[20].line
    assert_equal "2x 45km laps",             exe1.lines[21].line
    assert_equal "06073002.hrm",             exe1.lines[22].line

    exe2 = polar_file.sections[2]
    assert_equal "ExerciseInfo2", exe2.name
    assert_equal 23, exe2.lines.length
    assert_equal "Coomera BRICK",            exe2.lines[20].line
    assert_equal "easy run off the bike",    exe2.lines[21].line
    assert_equal "06073001.hrm",             exe2.lines[22].line



    
  end
  
  def test_day_description()
    #e = Exertion4::Modules::Polar::Polar.new
    exertion = Exertion4r.new('Polar', "./test/20060730.pdd")
    exertion.open
    
    day_desc = exertion.driver.polar_day_description
    assert_not_nil day_desc
    
    assert_equal 2, day_desc.exercise_infos.length
    
    ex_info_1 = day_desc.exercise_infos[0]
    ex_info_2 = day_desc.exercise_infos[1]
    
    assert_equal "06:18:39.0", ex_info_1.start_time
    assert_equal "09:35:47.0", ex_info_2.start_time
    
    assert_equal true, ex_info_1.smode_speed
    assert_equal true, ex_info_1.smode_cadence
    assert_equal true, ex_info_1.smode_altitude

    assert_equal true, ex_info_2.smode_speed
    assert_equal false, ex_info_2.smode_cadence
    assert_equal true, ex_info_2.smode_altitude
    
    assert_equal 193, ex_info_1.max_hr
    assert_equal 56, ex_info_1.rest_hr
    assert_equal 104, ex_info_1.weight

    
    
    
  end
    

end 

