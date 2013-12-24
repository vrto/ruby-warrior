class Player

  def initialize
    @direction = :backward
  end

  def play_turn(warrior)
    handle_direction(warrior)
    space = warrior.feel(@direction)
    if (should_turn_around?(warrior))
      then warrior.pivot!
    elsif (should_shoot?(warrior))
      then warrior.shoot!(@direction)
    elsif (should_run_away?(warrior))
      then warrior.walk!(:backward)
    elsif (safe_to_rest?(warrior, space))
      then warrior.rest!
    elsif (space.captive?)
      then warrior.rescue!(@direction)
    elsif (space.enemy?) 
      then warrior.attack!(@direction)
    else
      warrior.walk!(@direction)
    end

    @last_health = warrior.health
  end

  def safe_to_rest?(warrior, space)
    warrior.health < 20 && space.empty? && warrior.health >= @last_health
  end

  def handle_direction(warrior)
    if (warrior.feel(@direction).wall?) 
      then @direction = :forward
    end
  end

  def should_run_away?(warrior)
    # nil when start of the game
    @last_health != nil && warrior.health < 10 && warrior.health < @last_health
  end

  def should_turn_around?(warrior)
    @last_health == nil && warrior.feel(:forward).wall?
  end

  def should_shoot?(warrior)
    spaces = warrior.look
    should_shoot = false
    spaces.each { |space| 
      if (space.enemy?) 
        then should_shoot = true
      end   
    }
    should_shoot
  end

end
  