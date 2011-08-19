class Mate < ActiveRecord::Base
  
  def age
    if birthday
      now = Time.now
      age = now.year - birthday.year
      if now.month < birthday.month ||
         (now.month == birthday.month && now.day < birthday.day)
        age -= 1
      end
      return age
    end
    nil
  end
end
