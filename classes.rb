#useful classes
class Button #makes basic intractable buttons | (x, y, id, text)
  #Storing these in an array is recommended
  attr_reader :x, :y, :w, :h, :d, :anchor_x, :anchor_y, :r, :g, :b, :a, :blendmode_enum, :id, :active
  #args.outputs.borders << this
  #use an array for multiple buttons on screen

  @@all = []

  def self.all #keeps track of how many there are
    @@all
  end

  def initialize (x, y, id, text) #create buttons in an array (for rendering)
    @x = x
    @y = y
    @id = id #Abbreviation and Number recommended, i.e. MNU02
    @text = text.strip
    @active = true

    #the assumed dimensions of the default font; used for scaling the box
    @font_width = 10
    @font_height = 12

    #Scales to text
    @w = (2 + @text.length) * @font_width 
    @h = @font_height * 4 #Cannot be negative
    @@all << self

    #background variables
    @back_r = 239
    @back_g = 239
    @back_b = 239

    #text variables
    @text_r = 0
    @text_g = 0
    @text_b = 0
  end

  def primative_marker #makes this object a border 
    :border
  end

  def background # << args.outputs.solids; the background color
    {
      x: @x,
      y: @y,
      w: @w,
      h: @h,
      r: @back_r,
      g: @back_g,
      b: @back_b,
      primative_marker: :solid
    }
  end

  def text # << args.outputs.labels; the button text
    {
      x:  @x + @font_width,       #These two properties set the text in the center of the button
      y:  @y + @h - @font_height, #They should not be changed unless box size is changed
      text: @text,
      r: @text_r,
      g: @text_g,
      b: @text_b,
      primative_marker: :label
    }
  end

  ## UTILITY METHODS ##

  def change_position (new_x, new_y) #sets new position; based on box's bottom-left corner
    @x = new_x
    @y = new_y
  end

  def change_size (width = 0, height = 0) #changed border size; mind the text position
    @w = width
    @h = height

    @w = (2 + @text.length) * @font_width if @w <= 0 #values of zero or less reset to default
    @h = @font_height * 4 if @h <= 0 
  end

  def change_text (new_text) #changes button text; box resized automatically
    @text = new_text
    @text = "[text not set id: #{@id}]" if @text.strip == ""
    change_size
  end

  def change_background_color (r = 255, g = 255, b = 255) #no parameters resets to default 
    @back_r = r
    @back_g = g
    @back_b = b
  end

  def change_text_color (r = 0,g = 0,b = 0) #no parameters resets to default
    @text_r = r
    @text_b = b
    @text_g = g
  end

  def change_state (state = "") #no parameters flips the active state
    case state
    when true
      @active = true
    when false
      @active = false
    else
      @active = !@active
    end 
  end
end #end Button class



class Dice #A dice-based random number generator | Dice.roll(text = "", quantity = 1, sides = 6)
  #Only one type of die per call
  @@list = Hash.new{0}
  @@percents = Hash.new{0}

  def self.list #stores dice probabilities. Should not be called
    @@list 
  end


  def self.roll (text = "", quantity = 1, sides = 6) #regular dice roller
    if text != "" #parses text like 2d4 instead of traditional arguments. use one or the other
      quantity = text.split('d')[0].to_i
      sides = text.split('d')[1].to_i
    end

    total = 0
    quantity.times do
      total += rand(sides) + 1
    end
    @@quant = quantity
    @@sides = sides
    total
  end #end self.roll 

  def self.probabilities (dice_number = 2, sides = 6) #A tool for quickly getting the probabiliteis for any number of identical dice
    #returns a hash of {value => number of combinations that make that value}

    @@list.clear
    array = Array.new(dice_number, 1) #sets the temp array for the calculation
    ind = dice_number - 1 #sets the index. This will cycle thorough all the dice (one per loop)
    
    #return if list[dice_number] == 1 #return if this function has already been called. Useful when the tests were being done on the main tick function but probably redundant now that it's in a class. Keeping it available here just in case

    until array.first == -1 #until the first die has been reset
      result = 0 #initializes the sum result. May be redundant

      #if current die ("self") is the last element in the array
      if ind == dice_number - 1
        #if self has overflowed (been "reset") it is set to -1; this is so that no summing takes place until all overflows have been processed
        if array[ind] == -1
          #self is now properly reset to 1
          array[ind] = 1 
        #if self is not reset
        else
          #calculate and logs the sum of the array before moving on. This is the only condition that allows for this
          result = array.sum
          @@list[result] += 1 
          #if self is maxed out
          if array[ind] >= sides
            #self is -1
            array[ind] = -1
          #if self is not equal to the number of sides on a die ("maxed out")
          else
            #increment self
            array[ind] += 1
          end
        end
      #if self is not the last element
      else
        #checks if the next element has been reset
        if array[ind + 1] == -1
          #if self is maxed
          if array[ind] >= sides
            #self is reset
            array[ind] = -1
          #if self is not maxed
          else
            #self is incrimented
            array[ind] += 1           
          end
        #if next element is not reset
        else
          #if self reset
          if array[ind] == -1
            #self is 1
            array[ind] = 1
          #if self not reset
          else
            #Nothing happens and the loop moves on
          end
        end
      end
      #decrement index (this moves from right to left, althoug I don't think the direction actually matters)
      ind -= 1
      #reset the index after zero
      ind = dice_number - 1 if ind < 0
    end
    first = @@list.to_a.first[0]
    last = @@list.to_a.last[0]
    "#{first}d#{ (last/first).round } Occurances:  #{@@list.to_s} | #{sides ** dice_number} combinations"
  end #end self.probabilities 

  def self.percentages #gives percentages rounded up
    @@percents.clear
    quant = @@list.to_a.first[0]
    max = @@list.to_a.last[0]
    sides = (max/quant).round

    @@list.map do |k, v|
      @@percents[k] = (((v / sides ** quant) * 100).round(2))
    end
    "#{quant}d#{sides} Percentages: #{@@percents.to_s}"
  end

  def self.roll_a? (value = 0)
    percent = @@percents[value]
    occur = @@list[value]
    "Rolling a #{value}?   #{occur} occurances - #{percent}% likely"
  end

  #Wishlist:
  # - Custom dice method for mixing dice types (also with proof function) 
end #end Dice class



class TextBox #creates text boxes and scroll-able logs | (name, x_pos, y_pos, raw_text = "")
  attr_reader :name, :top, :bottom, :queue, :current_line, :last_in_queue

  @@all = []
  def self.all #access with TextBox.all
    @@all
  end

  def initialize (name, x_pos, y_pos, raw_text = "")
    #Meta
    @name = name
    @line_height = 25 #the spacing between each line of text
    @new_line_char = ";;" #this cant be accessed for some reason; make sure it's ' ;;'
    @@all << [@name, self.object_id, self]
    #Output Hash
    @x_pos = x_pos
    @y_pos = y_pos
    @raw_text = raw_text #the raw text
    @r_val = 0
    @g_val = 0
    @b_val = 0
    @alpha = 255
    @horizontal_alignment = 0 #0, 1, 2 >> left ,center, right
    @vertical_alignment = 0 #0, 1, 2 >> bottom, center, top
    @font_size_enum = 1
    #Typing
    @type_speed = 5 #1 = slow, 10 = fast
    @type_char = 0
    #Text Box Parameters
    @current_line = "" #the actual text of the current line
    @current_line_processed = "" #the visual representation of the current line
    @queue = [] #all the text that has been stored
    @text_box_height = 5 #amount of lines high the box is; includes type line
    @char_limit = 80
    #Indexes
    @reading_line = 0 #the line being read into the current_line
    @bottom = @reading_line - 1 #the bottom line of the scrolling text log
    @top = @bottom - @text_box_height + 2 #the top line of the scrolling text log
    @last_in_queue = @queue.length - 1 #the last index in the queue
    #Controls
    @auto_scroll = false
    @stop = false
  end

  def export_current_line #export *current_line* as hash
    {
      x: @x_pos - 23,
      y: @y_pos,
      text: "> #{@current_line_processed}",
      size_enum: @font_size_enum,
      alignment: @horizontal_alignment,
      r: @r_val,
      g: @g_val,
      b: @b_val,
      a: @alpha,
      vertical_alignment_enum: @vertical_alignment,
    }
  end

  def export_queue (text, y_offset) #export queue formatting as hash
    {
      x: @x_pos,
      y: @y_pos + @line_height + (@line_height * y_offset),
      text: text.to_s,
      size_enum: @font_size_enum,
      alignment: @horizontal_alignment,
      r: @r_val,
      g: @g_val,
      b: @b_val,
      a: @alpha,
      vertical_alignment_enum: @vertical_alignment
    }
  end


  def _type_current_line
    @type_char += @type_speed/10 if @type_char <= @current_line.length
    advance if @auto_scroll && @type_char == @current_line.length
    @current_line_processed = @current_line[0..@type_char]
  end

  def _word_wrap #splits the raw text into lines of char_limit and puts it in the queue
    result = ""
    splits = @raw_text.split()
    box = []
    
    splits.each do |s|
      if (s.include? @new_line_char)
        s.tr!(@new_line_char, '') #deletes new_line_char
        box << result #sends the current line through
        result = "#{s} " #resets new result
      elsif s.length + result.length > @char_limit 
        box << result #same as above
        result = "#{s} "
      else
        result += "#{s} "
      end
      #note that exactly one space will always go through even if the split clears itself (like \n\n)
    end

    box << result
    @queue += box
    @queue << ""
    @raw_text = ""
  end #end _word_wrap

  def _update #updates the relative variables
    return if @stop
    @text_box_height = 2 if @text_box_height < 2 #it breaks if lower than that
    @top = @bottom - @text_box_height + 2
    @top = 0 if @top < 0 
    @last_in_queue = @queue.length - 1
    @current_line = @queue[@reading_line] #HERE
  end

  def _convert
    @raw_text.gsub!("\n", " #{@new_line_char}")
  end

  def _process_text
    if @raw_text != ""
      _convert
      _word_wrap()
    end
    _update
  end

  def run (auto = false) # <<<< use to run/update text
    return if @stop 
    @auto_scroll = auto
    _process_text
    _type_current_line
    _update
  end

  def insert_raw_text (text) #use to continuously add text to the box
    return if text == nil
    @raw_text << text
    _update
    @reading_line += 1
    scroll_down
  end 

  #CONTROL METHODS: use these to interact with the text box itself
  def advance (jump = true) #use to skip a line
    @reading_line += 1 if @queue[@reading_line + 1] == " " && jump #automatically advances blank new line strings; because _word_wrap will always send at leas one space through, this checks for that
    @reading_line += 1 if @reading_line < @last_in_queue 
    @type_char = 0 #resets the type_char
    @bottom = @reading_line - 1 #reorients the box
    _update #updates variables
  end

  def skip #use to skip an entire entry
    @reading_line += 1 until @reading_line == @last_in_queue 
    @type_char = 0
    @bottom = @reading_line - 1
    _update
  end

  def scroll_up (amount = 1)
    @bottom -= 1 unless @bottom <= 0
    _update
  end

  def scroll_down (amount = 1)
    @bottom += 1 unless @bottom < 0 || @bottom >= @reading_line - 1
    _update
  end

  def activate
    @stop = false
  end

  def deactivate #Stops the text dead where it is and rejects input
    @stop = true
  end

  def clear_queue
    @stop = true
    @current_line = "nothing"
    @current_line_processed = @current_line
    @queue = []
    @stop = false
  end


  #SET METHODS: use these to manipulate box parameters. Calling each method without arguments resets it to default
  def set_raw_text (raw_text = "")
    @raw_text = raw_text
  end

  def set_color(r = 0, g = 0, b = 0)
    @r_val = r
    @g_val = g
    @b_val = b
  end

  def set_alpha (a = 255)
    @alpha = a
  end

  def set_alignment (hori = 0, vert = 0)
    @horizontal_alignment = hori
    @vertical_alignment = vert
  end

  def set_position (x = 0, y = 0)
    @x_pos = x
    @y_pos = y
  end

  def set_font_size_enum (font_size_enum = 1)
    @font_size_enum = font_size_enum
  end

  def set_type_speed (speed = 5)
    @type_speed = speed
  end

  def set_limits (char = 80, line = 5)
    @char_limit = char
    @text_box_height = line
  end

  def access_meta (name = @name, line_height = @line_height)
    @name = name
    @line_height = line_height
  end

  #Usage Notes:
  #text can read from array elements. These should be just strings

  #Remember to declare all objects as 'args.state.object ||= Class.new()' to avoid memory leak
  #Wishlist: 
  # - A hash for a border around the texts
  # - An option to reverse the direction the queue displays (writes top-down, scrolls up)
end #end TextBox class



class Timer #creates clocks and timers | (name, reset_value, type)

  attr_reader :name, :current_time, :permission, :active #can be read if needed but not modified directly

  @@all = []
  def self.all #access with TextBox.all
    @@all
  end


  def initialize (name, reset_value, type)
  	@name = name
    #sets the counting direction based on reset value
    if reset_value <= 0
    	@reset_value = 0
    	@direction = 'up'
    else
    	@reset_value = reset_value
    	@direction = 'down'
    end

    @current_time = @reset_value
    @permission = true #can be used to trigger events when count reches zero
    @active = false
    @permission_type = type #clock, cooldown, running (see _grant_permissions)

    if @direction == 'up'
      puts "Timer: #{@name.upcase} has been set to 'running' because its reset_value was initialized to 0 | Object ID: #{self.object_id}" if @permission_type != 'running'
      @permission_type = 'running' 
    end

    @@all << [@name, self.object_id, self]

    _grant_permissions
  end #end initialize

  #FUNCTIONAL METHODS: DO NOT CALL
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
  def _count (increment = 1) #moves the clock by increment based on direction
    if @direction == 'up'
      @current_time += increment
    else
      @current_time -= increment
    end 
  end #end _count

  def _grant_permissions #sets a flag which can be used to trigger external events
    #CLOCK:  Use like a clock
    #COOLDOWN: if the timer is at its reset value, permission. 
    #RUNNING: if the timer is running, permission. Opposite of ZERO
    case @permission_type
    when 'clock'
      if @current_time == 0
        @permission = true
      else 
        @permission = false
      end
    when 'cooldown'
      if @current_time == @reset_value
        @permission = true
      else 
        @permission = false
      end        
    when 'running'
      if @current_time > 0
        @permission = true
      else 
        @permission = false
      end        
    end

  end #end _grant_permissions

  def _reset
    return if @permission_type == 'running'
    if @current_time == 0
      @current_time = @reset_value 
      @active = false if @permission_type == 'cooldown'
    end
    #No reset for running timers
  end #end _reset

  def _convert_to_time (frames) #converts the cycle count to a readable time and returns it as a string
    deciseconds = (frames.mod(60) / 0.6).to_i
    seconds = frames.idiv(60).mod(60)
    minutes = frames.idiv(3600).mod(60)
    hours = frames.idiv(216000)

    "#{hours > 9 ? "" : "0"}#{hours}:#{minutes > 9 ? "" : "0"}#{minutes}:#{seconds > 9 ? "" : "0"}#{seconds}.#{deciseconds > 9 ? "" : "0"}#{deciseconds}"
  end #end _convert_to_time


  ### UTILITY METHODS ###

  def run (increment = 1) #main method for running timer
    _grant_permissions if @permission_type != 'clock'
    return if !@active #breaks out if inactive
    _count
    _grant_permissions if @permission_type == 'clock'
    _reset
  end #end run

  def display #puts the timer status and info in a string for ease of reading
  	"#{@name}: #{_convert_to_time(@current_time)} | #{@reset_value} (#{@direction == 'up' ? "+" : "-"}), Permission type: #{@permission_type} - #{@permission} #{@permission == true ? " " : ""}| Active: #{@active}"
  end #end display

  def add_seconds (seconds) #use to add seconds to the timer
  	@current_time += (seconds * 60)
  	@current_time = 0 if @current_time < 0
  end #end add_seconds

  def add_frames (frames) #use to add game cycles to the timer
  	@current_time += frames
  	@current_time = 0 if @current_time < 0
  end #end add_frames

  def activate #use to start a timer
  	@active = true
  end #end activate

  def deactivate #use to pause a timer
  	@active = false
  end #end deactivate

  def flip_state #use to toggle activation state
    @active = !@active
  end #end flip_state

  def reset_timer #I think 'reset' is a reserved word in ruby
    @current_time = @reset_value
  end
end #end Timer class
