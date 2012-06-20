module Conditions
  
  #
  # It represents the join of two or more conditions
  # 
  class JoinComparison < AbstractComparison
  
    attr_reader :operator
    attr_reader :conditions
  
    #
    # Creates 
    #
    # @param [String] operator
    #
    # @param [Array] conditions
    #
    #   Array of Comparison which holds all the comparisons
    #
    def initialize(operator, conditions)
    
      raise "Operator #{operator} is not valid" if not check_operator(operator)
      raise "Conditions are not valid. They must be an array of Comparison or JoinComparison" if not check_conditions(conditions) 
      
      @operator = operator
      @conditions = conditions
    
    end
  
    #
    # Check if the condition is valid
    #
    # @param [Object]
    #  The object where the condition will be checked
    #
    # @return [Boolean]
    #  Condition evaluation
    #  
    def check(object)
    
      case operator
      
        when '$or'
           
           result = false
           conditions.each do |condition|
             if condition.check(object)
               result = true
               break
             end      
           end
           
        when '$and'

           result = true
           conditions.each do |condition|
             if not condition.check(object)
               result = false
               break
             end      
           end
        
      end

      result
    
    end
  
    private
    
    #
    # Check if the operator is valid
    #
    # @param [String] operator
    #
    # @return [Boolean]
    #
    #  If the operator is valid
    #
    def check_operator(operator)
    
      not JoinComparison.operators.index(operator).nil?
    
    end
    
    #
    # Check if the conditions are valid
    #
    # @param [Array] conditions
    #
    # @return [Boolean]
    #
    #  If the conditions are valid
    #
    def check_conditions(conditions)
    
      if not conditions.kind_of?(Enumerable)
        return false
      end
      
      value = true
                  
      conditions.each do |condition|
        
        if not condition.kind_of?(Comparison) and not condition.kind_of?(JoinComparison)
          value = false
          break
        end
        
      end
      
      value
      
    end
    
    #
    # Retrieve the valid operators
    #
    def self.operators
    
      ['$and', '$or']
    
    end
   
  end

end #Conditions