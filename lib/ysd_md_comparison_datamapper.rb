require 'dm-core' unless defined?DataMapper

module Conditions
  
  #
  # It's a module which extends the JoinComparison class to generate the
  # conditions in SQL way
  #
  module JoinComparisonDataMapperBuilder  

    #
    # Build conditions from a join comparison
    #
    def build_datamapper(model, opts={})
     
     conditions.inject(nil) do |result, item|
       condition = item.build_datamapper(model, opts)
       unless result.nil?
         condition = case operator
                      when '$or'
                        result.union(condition)
                      when '$and'
                        result.intersection(condition)
                     end
       end
       condition
     end

    end

  end    

  #
  # It's a module which extends the SimpleComparison class to generate the
  # conditions in SQL way
  #
  module SimpleComparisonDataMapperBuilder
    
    #
    # Build conditions from a simple comparison
    #
    def build_datamapper(model, opts={})
           
      # Directly through the model because the query loses default_scope

      #DataMapper::Query.new(repository, model, :conditions => condition)
      #repository.new_query(model, :conditions => condition)
      
      model.all(prepare_condition.merge(opts))

    end

    def count_datamapper(model)

      model.count(prepare_condition)

    end

    def prepare_condition

      elements = field.to_s.split('.')
      
      condition = build_condition(elements.pop, operator, value)
      
      if elements.length > 0
        elements.push(condition)
        condition = elements[0..-3].reverse.inject({elements[-2] => elements[-1]}) { |result, item| {item.to_sym=>result} }
      end
      
      return condition

    end
        
    #
    # @return Hash with the condition
    #
    def build_condition(field, operator, value)

      result = case operator
                 when '$eq'
                   {field.to_sym => value}
                 when '$ne'
                   {field.to_sym.send(:not) => value}
                 when '$in'
                   {field.to_sym => Array(value)}
                 #when '$all'
                 when '$lt'
                   {field.to_sym.send(:lt) => value}              
                 when '$gt'
                   {field.to_sym.send(:gt) => value}                
                 when '$lte'
                   {field.to_sym.send(:lte) => value}              
                 when '$gte'
                   {field.to_sym.send(:gte) => value}
                 when '$not'
                   {field.to_sym.send(:not) => value}
                 when '$like'
                   {field.to_sym.send(:like) => value}  
              end      

    end 

  end
  
  # Includes the builder in clases
  
  class Comparison
    include SimpleComparisonDataMapperBuilder
  end
  
  class JoinComparison
    include JoinComparisonDataMapperBuilder
  end
  
end