#Class-specific modules
module ButtonTools
  # Use the following to utilize Button Class
  def render_buttons (args, array) #use to reder array of buttons on screen
    array.each do |b| 
      args.outputs.borders << b
      args.outputs.labels << b.text
      args.outputs.solids << b.background

      if b.active == false
        #you can put stuff here; remember this is called every frame 
      end
    end
  end #end render_buttons

  def find_button (args, array) #Sees if the mouse is on buttons from the array and returns object
    #When searching for a specific property of a button (i.e. @active) you may need to attach '&' to the end of the call but before the property you're looking for. This will ignore nil values.
    #i.e. find_button(args, button_array)&.active --> returns button's active value, ignoring nil

    array.find do |b|
      #<DO SOMETHING> if b.active == false <-- use this for inactive behavior; remember it's called every frame
      b if args.inputs.mouse.intersect_rect? b
    end
  end #end find_button
end #end ButtonTools module


module DiceTools #only useful for debugging/testing
  def full_stats (args, x, y, dice_quant = 2, dice_sides = 6, roll_a = 12)
    args.outputs.labels << [x, y, Dice.probabilities(dice_quant, dice_sides)]
    args.outputs.labels << [x, y - 20, Dice.percentages]
    args.outputs.labels << [x, y - 40, Dice.roll_a?(roll_a)]
  end
end #end DiceTools module

module TextTools #Realization Methods are the only useful ones right now
  #NOTE: This module needs some specific variables or constants to work properly
  #Needed variables: VAR (as it appears in the current code)
  # - the actual TEXT (args.state.text / args.state.demo)
  # - X and Y positions for the text being used (x_pos, y_pos)
  # - text scroll SPEED; number from 1 to 10
  # - some kind of INDEX for the current character being typed (type_num)
  # - a CHARACTER LIMIT
  # - an ARRAY that stores the text after it's broken up (text_array) [could just use the args_split_text method since it returns an array]
  # - an external (?) ARRAY for TextBox objects [I might have fixed this already; check full_text_object method]

  #Methods that mimic the TextBox class - - - - - - - - - - - - - - - - - - - - - - - - - -
  def args_type_line (args, text, speed = 10) #types each character of a line; speed should be from 1 - 10
    if text == ""
      args.outputs.labels << {
        x: text.x_pos, #SET
        y: (text.y_pos + 25).from_top, #SET
        text: "Input_",
      }
      return
    end

    #MIND THESE VARIABLES
    args.state.text.type_num += speed/10 if args.state.text.type_num <= text.length

    args.outputs.labels << [text.x_pos, (text.y_pos + 25).from_top, text[0..args.state.text.type_num]]
  end #end args_type_line

  def args_split_text (args, text) #breaks up the text and outputs it as an array
    splits = args.string.wrapped_lines(text, args.state.text.char_limit)
    splits << ""
    splits
  end #end args_split_text

  def args_scrollling_array (args, x_pos, y_pos, text_array) #scrolls bottom-up
    top = text_array.top #SET THIS - the top of the visible array
    bottom = text_array.bottom #SET THIS - the last visible line (or penultimate, if typebox underneath)
    return if bottom < 0

    text_array[top..bottom].reverse.each_with_index do |t, i|
      args.outputs.labels << [x_pos, (y_pos - i * 25).from_top, t]
    end
  end #end args_scrolling_array


  # - - - - - - - - - - Methods to realize the TextBox Class - - - - - - - - - - 
  module TextObjectRenderer
    def scrolling_object (args, text_object) #use to get the queue only
      top = text_object.top
      bottom = text_object.bottom
      return if bottom < 0
      return if text_object.queue == []

      text_object.queue[top..bottom].reverse.each_with_index do |t, i|
        args.outputs.labels << text_object.export_queue(t, i)
      end
    end #end scrolling_object

    def full_textbox_object (args, text_object) #reads queue, type_line and basic controls

      scrolling_object(args, text_object)

      args.outputs.labels << text_object.export_current_line

      #advance text
      if key_inputs(args)[:sup1]
        text_object.advance
      end

      #scroll queue
      if key_inputs(args)[:directional][1] > 0
        text_object.scroll_up
        #update box top here so it doesnt flicker
      elsif key_inputs(args)[:directional][1] < 0
        text_object.scroll_down
      end
    end #end full_text_object
  end #end TextObjectRenderer sub-module 
end #end TextTools module
