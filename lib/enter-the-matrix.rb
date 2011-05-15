require 'active_support'
module EnterTheMatrix


  def self.included(base)
    base.extend ClassMethods
  end


  module ClassMethods


    def responds_to_matrix(relation, key, options)
      check_options options
      options[:with].each do |w|
        class_eval <<-EOV
          def #{w}_#{relation}
            if(relation = #{relation.capitalize}.where(:#{key} => "#{w}").first)
              return relation.#{key}
            end
            return #{options[:default]}
          end
        EOV
      end
    end

    
    private


    def check_options(options)
      if(!options.has_key? :with)
        raise "With not set"
      end

      if(!options.has_key? :default)
        raise "Default not set"
      end
    end


  end
end

ActiveRecord::Base.send(:include, EnterTheMatrix)
