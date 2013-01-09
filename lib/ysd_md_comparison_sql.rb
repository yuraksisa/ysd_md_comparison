module Conditions

  #
  # It builds the conditions for SQL 
  #
  class SQLConditionBuilder < Hash 
  
    def initialize(comparison)
      @comparison = comparison
      merge!(comparison.build_mongodb)
    end

  end
  
  #
  # It's a module which extends the JoinComparison class to generate the
  # conditions in SQL way
  #
  module JoinComparisonSQLBuilder  
    
    #
    # Build conditions from a join comparison
    #
    def build_sql
     
     built_conditions = []
     built_params = []
     
     conditions.each do |condition|
     
       condition, *params = condition.build_sql
       
       built_conditions << condition
       built_params.concat(params)
       
     end
    
     ["(#{built_conditions.join(" #{operator.sub('$','')} ")})"].concat(built_params)
     
    end
    
  end    

  #
  # It's a module which extends the SimpleComparison class to generate the
  # conditions in MongoDB way
  #
  module SimpleComparisonSQLBuilder
    
    #
    # Build conditions from a simple comparison
    #
    def build_sql
            
      result = case operator
                 when '$eq'
                   if value.nil?
                     ["#{field} is null"]
                   else
                     ["#{field} = ?",value]
                   end
                 when '$in'
                   ["#{field} in (?)", Array(value).join(',')]
                 #when '$all'
                 when '$lt'
                   ["#{field} < ?",value]                 
                 when '$gt'
                   ["#{field} > #{value}",value]                 
                 when '$lte'
                   ["#{field} <= #{value}",value]                 
                 when '$gte'
                   ["#{field} >= #{value}",value]      
              end
      result
    
    end
      
  end
  
  # Includes the builder in clases
  
  class Comparison
    include SimpleComparisonSQLBuilder
  end
  
  class JoinComparison
    include JoinComparisonSQLBuilder
  end
  
end