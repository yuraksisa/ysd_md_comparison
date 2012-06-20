module Conditions

  #
  # It builds the conditions for MongoDB 
  #
  class MongoDBConditionBuilder < Hash 
  
    def initialize(comparison)
      @comparison = comparison
      merge!(comparison.build_mongodb)
    end

  end
  
  #
  # It's a module which extends the JoinComparison class to generate the
  # conditions in MongoDB way
  #
  module JoinComparisonMongoDBBuilder  
    
    #
    # Build conditions from a join comparison
    #
    def build_mongodb
    
     result = case operator
                 when '$and'
                   temp = {}
                   conditions.each { |condition| temp.merge!(condition.build_mongodb) }   
                   temp                
                 when '$or'                
                   { '$or' => conditions.map { |condition| condition.build_mongodb } } 
               end
               
    end
    
  end    

  #
  # It's a module which extends the SimpleComparison class to generate the
  # conditions in MongoDB way
  #
  module SimpleComparisonMongoDBBuilder
    
    #
    # Build conditions from a simple comparison
    #
    def build_mongodb
    
      result = case operator
                 when '$eq'
                   {field => value}
                 when '$in', '$all' 
                   {field => {operator => Array(value)}}
                 else
                   {field => {operator => value}}
                 end
      
      result
    
    end
      
  end # MondoDBComparisonBilder
  
  # Includes the builder in clases
  
  class Comparison
    include SimpleComparisonMongoDBBuilder
  end
  
  class JoinComparison
    include JoinComparisonMongoDBBuilder
  end
  
end
