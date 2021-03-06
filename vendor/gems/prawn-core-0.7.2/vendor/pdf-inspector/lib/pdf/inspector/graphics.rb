module PDF
  class Inspector 
    module Graphics                   
      class Line < Inspector
        attr_accessor :points, :widths

        def initialize
          @points = []
          @widths = [] 
        end  

        def append_line(*params)
          @points << params
        end    

        def begin_new_subpath(*params)
          @points << params
        end           
        
        def set_line_width(params)
          @widths << params
        end

      end 
      
      class Rectangle < Inspector
        attr_reader :rectangles

        def initialize
          @rectangles = []     
        end

        def append_rectangle(*params) 
          @rectangles << { :point  => params[0..1],    
                           :width  => params[2],
                           :height => params[3]  }     
        end
      end
      
      class Curve < Inspector

        attr_reader :coords

        def initialize
          @coords = []          
        end   

        def begin_new_subpath(*params)   
          @coords += params
        end

        def append_curved_segment(*params)
          @coords += params
        end           

      end   
      
      class Color < Inspector
        attr_reader :stroke_color, :fill_color, :stroke_color_count, 
                    :fill_color_count

        def initialize
          @stroke_color_count = 0
          @fill_color_count   = 0
        end

        def set_color_for_stroking_and_special(*params)
          @stroke_color_count += 1
          @stroke_color = params
        end

        def set_color_for_nonstroking_and_special(*params)
          @fill_color_count += 1
          @fill_color = params
        end
      end 
      
      class Dash < Inspector
        attr_reader :stroke_dash, :stroke_dash_count

        def initialize
          @stroke_dash_count = 0
        end

        def set_line_dash(*params)
          @stroke_dash_count += 1
          @stroke_dash = params
        end
      end
      
      class CapStyle < Inspector
        attr_reader :cap_style, :cap_style_count

        def initialize
          @cap_style_count = 0
        end

        def set_line_cap_style(*params)
          @cap_style_count += 1
          @cap_style = params[0]
        end
      end
      
      class JoinStyle < Inspector
        attr_reader :join_style, :join_style_count

        def initialize
          @join_style_count = 0
        end

        def set_line_join_style(*params)
          @join_style_count += 1
          @join_style = params[0]
        end
      end
      
    end                                
  end
end
