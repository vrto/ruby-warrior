class Player

  def initialize
    @warrior = nil
    @bowman_alive = true
    @green_monster_alive = true
    @wizard_alive = true
    @walk_to_wizard = true
    @right_cage_rescued = false
    @left_cage_rescued = false
    @turned_around = false
  end

  def play_turn(warrior)
    @warrior = warrior
    if (should_rest?) then
      warrior.rest!
    elsif (@bowman_alive) then
      try_kill_bowman()
    elsif (@green_monster_alive) then
      try_kill_green_monster()
    elsif (@wizard_alive) then
      try_kill_wizard()
    elsif (@right_cage_rescued == false) then
      try_rescue_right_cage()
    elsif (@left_cage_rescued == false) then
      try_rescue_left_cage()
    else
      walk_to_finish()
    end  
  end

  def should_rest?()
    @bowman_alive == false && @warrior.health <= 14
  end

  def try_kill_bowman()
    alive = shoot_to_kill?(:backward)
    if (!alive) then
      @bowman_alive = false
    end
  end

  def try_kill_green_monster()
    alive = shoot_to_kill?(:forward)
    if (!alive) then
      @green_monster_alive = false
    end
  end

  def try_kill_wizard() 
    if (!enemy_ahead? && @walk_to_wizard)
      @warrior.walk!
      @walk_to_wizard = false
    else
      alive = shoot_to_kill?(:forward)
      if (!alive) then
        @wizard_alive = false
      end
    end
  end

  def try_rescue_right_cage()
    rescued = rescued_space?(@warrior.feel)
    if (rescued) then
      @right_cage_rescued = true
    end
  end

  def try_rescue_left_cage()
    if !(@turned_around) then
      @warrior.pivot!
      @turned_around = true
    else
      rescued = rescued_space?(@warrior.feel)
      if (rescued) then
        @left_cage_rescued = true
      end
    end
  end

  def walk_to_finish()
    @warrior.walk!
  end

  def shoot_to_kill?(direction)
    spaces = @warrior.look(direction)
    still_alive = false
    spaces.each { |space| 
      if (space.enemy?) then
        @warrior.shoot!(direction)
        still_alive = true
      end
    }
    still_alive
  end

  def enemy_ahead?() 
    spaces = @warrior.look(:forward)
    has_enemy = false
    spaces.each { |space| 
      if (space.enemy?) then
        has_enemy = true
      end
    }
    has_enemy
  end

  def rescued_space?(space)
    if (space.captive?) then
      @warrior.rescue!
      return true
    else
      @warrior.walk!
      return false
    end
  end

end
  