module Conditions

  #
  # It represent the base class for all the comparisons
  #
  class AbstractComparison
  
    def check(object)
      raise "The method has to be implemented in the subclases" 
    end

  end
end