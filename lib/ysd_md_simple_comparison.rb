module Conditions
   
  #
  # It represents a single comparison
  # 
  class Comparison < AbstractComparison
    
    attr_reader :field
    attr_reader :operator
    attr_reader :value

    #
    # Constructs a comparisson instance
    #     
    def initialize(field, operator, value)
     
      raise "Operator #{operator} not valid" if not check_operator(operator)
      
      @field = field.to_sym
      @operator = operator
      @value = value
    
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
    
      #puts "check : operator = #{operator} value = #{value} field = #{field} object = #{object.inspect} #{object.send(field)} #{object.send(field).class.name}"
    
      case operator
        
        when '$eq'
        
          object.send(field) == value
        
        when '$ne'
        
          object.send(field) != value
        
        when '$in'
        
          not Array(value).index(object.send(field)).nil?
        
        when '$lt'
        
          object.send(field) < value
                
        when '$gt'
        
          object.send(field) > value
        
        when '$lte'
        
          object.send(field) <= value
        
        when '$gte'
        
          object.send(field) >= value
     
      end
    
    end
    
    alias_method :checks, :check
       
    private
    
    #
    # Check if it's a valid operator
    #
    # @param [String] operator
    #   The operator to check
    #
    # @return [Boolean]
    #   If it's a valid operator
    #
    def check_operator(operator)
  
      not Comparison.operators.index(operator).nil?
    
    end
  
    #
    # Return the valid operators
    #
    def self.operators
    
      ['$eq', '$ne', '$in', 
       '$lt', '$gt', '$lte', '$gte', '$like']  
    
    end
  
  end

end #Conditions