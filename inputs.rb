#Input management
def input_manager (args) #put variables here
	#Frame data
	args.state.inputs.frames.click ||= 0
	args.state.inputs.frames.directional ||= 0
	args.state.inputs.frames.primary ||= 0
	args.state.inputs.frames.secondary ||= 0
	args.state.inputs.frames.tertiary ||= 0
	args.state.inputs.frames.quaternary ||= 0
	args.state.inputs.frames.start ||= 0
	args.state.inputs.frames.select_input ||= 0
	args.state.inputs.frames.sup_1 ||= 0
	args.state.inputs.frames.sup_2 ||= 0
	#and so on...

end

module InputTools

  module Keyboard #keyboard only control methods

    def directional_input (args, type = '', side = '') #retuns array with the values of x and y
      x = args.inputs.left_right
      y = args.inputs.up_down 
      args.state.inputs.frames.directional = args.state.tick_count if x != 0 || y != 0
      
      [x, y, args.state.inputs.frames.directional]
    end #end directional_input

    #Input Types:
    # - hold
    # - press (down one frame)
    # - release (key up)
    #Input Sides:
    # - all
    # - left (wasd, jkl;)

    def primary_button_input (args, type = 'hold', side = 'all')
      value = false

      case side
      when 'left'
        case type
        when 'press'
          args.inputs.keyboard.key_down.c ? value = true : value = false
        when 'hold'
          args.inputs.keyboard.key_held.c ? value = true : value = false
        when 'release'
          args.inputs.keyboard.key_up.c ? value = true : value = false
        end #end type case

      when 'right'
        case type
        when 'press'
          args.inputs.keyboard.key_down.j ? value = true : value = false
        when 'hold'
          args.inputs.keyboard.key_held.j ? value = true : value = false
        when 'release'
          args.inputs.keyboard.key_up.j ? value = true : value = false
        end #end type case

      when 'all'
      	case type
      	when 'press'
      	  args.inputs.keyboard.key_down.j || args.inputs.keyboard.key_down.c ? value = true : value = false
      	when 'hold'
      	  args.inputs.keyboard.key_held.j || args.inputs.keyboard.key_held.c ? value = true : value = false
      	when 'release'
      	  args.inputs.keyboard.key_up.j || args.inputs.keyboard.key_up.c ? value = true : value = false
      	end #end type case
      end #end side case

      args.state.inputs.frames.primary = args.state.tick_count if value == true

      {
        value: value,
        type: type,
        frame: args.state.inputs.frames.primary,
        side: side
      }

    end #end primary_button_input

    def secondary_button_input (args, type = 'hold', side = 'all') #k, x
    	value = false

    	case side
    	when 'left'
    	  case type
    	  when 'press'
    	    args.inputs.keyboard.key_down.x ? value = true : value = false
    	  when 'hold'
    	    args.inputs.keyboard.key_held.x ? value = true : value = false
    	  when 'release'
    	    args.inputs.keyboard.key_up.x ? value = true : value = false
    	  end #end type case

    	when 'right'
    	  case type
    	  when 'press'
    	    args.inputs.keyboard.key_down.k ? value = true : value = false
    	  when 'hold'
    	    args.inputs.keyboard.key_held.k ? value = true : value = false
    	  when 'release'
    	    args.inputs.keyboard.key_up.k ? value = true : value = false
    	  end #end type case

    	when 'all'
    		case type
    		when 'press'
    		  args.inputs.keyboard.key_down.x || args.inputs.keyboard.key_down.k ? value = true : value = false
    		when 'hold'
    		  args.inputs.keyboard.key_held.x || args.inputs.keyboard.key_held.k ? value = true : value = false
    		when 'release'
    		  args.inputs.keyboard.key_up.x || args.inputs.keyboard.key_up.k ? value = true : value = false
    		end #end type case
    	end #end side case

    	args.state.inputs.frames.secondary = args.state.tick_count if value == true

    	{
    	  value: value,
    	  type: type,
    	  frame: args.state.inputs.frames.secondary,
    	  side: side
    	}
    end #end secondary_button_input

    def tertiary_button_input (args, type = 'hold', side = 'all') #l, z
    	value = false

    	case side
    	when 'left'
    	  case type
    	  when 'press'
    	    args.inputs.keyboard.key_down.z ? value = true : value = false
    	  when 'hold'
    	    args.inputs.keyboard.key_held.z ? value = true : value = false
    	  when 'release'
    	    args.inputs.keyboard.key_up.z ? value = true : value = false
    	  end #end type case

    	when 'right'
    	  case type
    	  when 'press'
    	    args.inputs.keyboard.key_down.l ? value = true : value = false
    	  when 'hold'
    	    args.inputs.keyboard.key_held.l ? value = true : value = false
    	  when 'release'
    	    args.inputs.keyboard.key_up.l ? value = true : value = false
    	  end #end type case

    	when 'all'
    		case type
    		when 'press'
    		  args.inputs.keyboard.key_down.z || args.inputs.keyboard.key_down.l ? value = true : value = false
    		when 'hold'
    		  args.inputs.keyboard.key_held.z || args.inputs.keyboard.key_held.l ? value = true : value = false
    		when 'release'
    		  args.inputs.keyboard.key_up.z || args.inputs.keyboard.key_up.l ? value = true : value = false
    		end #end type case
    	end #end side case

    	args.state.inputs.frames.tertiary = args.state.tick_count if value == true

    	{
    	  value: value,
    	  type: type,
    	  frame: args.state.inputs.frames.tertiary,
    	  side: side
    	}
    end #end tertiary_button_input

    def quaternary_button_input (args, type = 'hold', side = 'all') #;, v
    	value = false

    	case side
    	when 'left'
    	  case type
    	  when 'press'
    	    args.inputs.keyboard.key_down.v ? value = true : value = false
    	  when 'hold'
    	    args.inputs.keyboard.key_held.v ? value = true : value = false
    	  when 'release'
    	    args.inputs.keyboard.key_up.v ? value = true : value = false
    	  end #end type case

    	when 'right'
    	  case type
    	  when 'press'
    	    args.inputs.keyboard.key_down.semicolon ? value = true : value = false
    	  when 'hold'
    	    args.inputs.keyboard.key_held.semicolon ? value = true : value = false
    	  when 'release'
    	    args.inputs.keyboard.key_up.semicolon ? value = true : value = false
    	  end #end type case

    	when 'all'
    		case type
    		when 'press'
    		  args.inputs.keyboard.key_down.v || args.inputs.keyboard.key_down.semicolon ? value = true : value = false
    		when 'hold'
    		  args.inputs.keyboard.key_held.v || args.inputs.keyboard.key_held.semicolon ? value = true : value = false
    		when 'release'
    		  args.inputs.keyboard.key_up.v || args.inputs.keyboard.key_up.semicolon ? value = true : value = false
    		end #end type case
    	end #end side case

    	args.state.inputs.frames.quaternary = args.state.tick_count if value == true

    	{
    	  value: value,
    	  type: type,
    	  frame: args.state.inputs.frames.primary,
    	  side: side
    	}
    end #end quaternary_button_input

    def start_button_input (args, type = 'hold')
    	case type
    	when 'press'
    	  args.inputs.keyboard.key_down.enter ? value = true : value = false
    	when 'hold'
    	  args.inputs.keyboard.key_held.enter ? value = true : value = false
    	when 'release'
    	  args.inputs.keyboard.key_up.enter ? value = true : value = false
    	end #end type case
    	{
    	  value: value,
    	  type: type,
    	  frame: args.state.inputs.frames.start
    	}

    end #end start_button_input

    def select_button_input (args, type = 'hold') #remember 'select' by itself is a reserved word in ruby
    	case type
    	when 'press'
    	  args.inputs.keyboard.key_down.shift ? value = true : value = false
    	when 'hold'
    	  args.inputs.keyboard.key_held.shift ? value = true : value = false
    	when 'release'
    	  args.inputs.keyboard.key_up.shift ? value = true : value = false
    	end #end type case

    	{
    	  value: value,
    	  type: type,
    	  frame: args.state.inputs.frames.select_input,
    	}

    end #end select_button_input

    def supplemental_button_one_input (args, type = 'hold', side = 'all') 
    	value = false

    	case side
    	when 'left'
    	  case type
    	  when 'press'
    	    args.inputs.keyboard.key_down.e ? value = true : value = false
    	  when 'hold'
    	    args.inputs.keyboard.key_held.e ? value = true : value = false
    	  when 'release'
    	    args.inputs.keyboard.key_up.e ? value = true : value = false
    	  end #end type case

    	when 'right'
    	  case type
    	  when 'press'
    	    args.inputs.keyboard.key_down.space ? value = true : value = false
    	  when 'hold'
    	    args.inputs.keyboard.key_held.space ? value = true : value = false
    	  when 'release'
    	    args.inputs.keyboard.key_up.space ? value = true : value = false
    	  end #end type case

    	when 'all'
    		case type
    		when 'press'
    		  args.inputs.keyboard.key_down.e || args.inputs.keyboard.key_down.space ? value = true : value = false
    		when 'hold'
    		  args.inputs.keyboard.key_held.e || args.inputs.keyboard.key_held.space ? value = true : value = false
    		when 'release'
    		  args.inputs.keyboard.key_up.e || args.inputs.keyboard.key_up.space ? value = true : value = false
    		end #end type case
    	end #end side case

    	args.state.inputs.frames.quaternary = args.state.tick_count if value == true

    	{
    	  value: value,
    	  type: type,
    	  frame: args.state.inputs.frames.primary,
    	  side: side
    	}

    end #end supplemental_button_one_input

    def key_inputs (args) #a template. Add and name all the key presses you're looking for here
      {
        directional: directional_input(args)[0..1],
        primary: primary_button_input(args)[:value],
        secondary: secondary_button_input(args)[:value],
        tertiary: tertiary_button_input(args)[:value],
        quaternary: quaternary_button_input(args)[:value],
        start: start_button_input(args)[:value],
        select: select_button_input(args)[:value],
        sup1: supplemental_button_one_input(args)[:value],
      }
    end #end keyboard_debug

    def render_key_inputs (args, x = 20, y = 600)
      thing = key_inputs(args)

      thing.each_with_index do |(k, v), i|
        args.outputs.debug << [x, (y - 20 * i), "#{k}: #{v}"].label
      end
    end #end render_key_inputs
  end #end KeyboardOnly sub-module

  module KeyboardAndMouse
  	include Keyboard

  	def mouse_input (args, type = 'press') #'hold' doesn't seem to work here
  		x = args.inputs.mouse.x
  		y = args.inputs.mouse.y
  		c = args.inputs.mouse.click ? true : false

  		case type
  		when 'press'
  			args.inputs.mouse.click ? c = true : c = false
  		when 'hold'
  			args.inputs.mouse.down ? c = true : c = false
  		when 'release'
  			args.inputs.mouse.up ? c = true : c = false
  		end #end case

  		args.state.inputs.frames.click = args.state.tick_count if c 

  		{
  			x: x,
  			y: y,
  			value: c, 
  			type: type,
  			frame: args.state.inputs.frames.click
  		}
  	end #end mouse_inputs

  	def key_mou_inputs (args, x = 20, y = 300)
  		{
  			mouse_x: mouse_input(args)[:x],
  			mouse_y: mouse_input(args)[:y],
  			mouse_value: mouse_input(args)[:value],
  		  directional: directional_input(args, 'hold', 'left')[0..1],
  		  start: start_button_input(args, 'hold')[:value],
  		  select: select_button_input(args, 'hold')[:value],
  		  sup1: supplemental_button_one_input(args, 'hold', 'left')[:value],
  		}
  	end #end render_key_mou_inputs

  	def render_key_mou_inputs (args, x = 20, y = 400)
  	  thing = key_mou_inputs(args)

  	  thing.each_with_index do |(k, v), i|
  	    args.outputs.debug << [x, (y - 20 * i), "#{k}: #{v}"].label
  	  end
  	end #end render_key_inputs

  end #end KeyboardAndMouse sub-module

  #Wishlist:
  # - a way to specify the duration for each input
  # - a way to specify which side of the keyboard is being read
end #end InputTools module

