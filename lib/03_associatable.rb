require_relative '02_searchable'
require 'active_support/inflector'

class AssocOptions
  attr_accessor(
    :foreign_key,
    :class_name,
    :primary_key
  )

  def model_class
    class_name.constantize
  end

  def table_name
    "#{class_name.to_s.underscore}s"
  end
end

class BelongsToOptions < AssocOptions
  def initialize(name, options = {})
    @name = name
    @options = options
  end

  def foreign_key
    @options[:foreign_key] || "#{@name}_id".to_sym
  end

  def primary_key
    @options[:primary_key] || :id
  end

  def class_name
    @options[:class_name] || "#{@name}".camelcase
  end

end

class HasManyOptions < AssocOptions
  def initialize(name, self_class_name, options = {})
    @name = name
    @self_class_name = self_class_name
    @options = options
  end

  def foreign_key
    @options[:foreign_key] || "#{@self_class_name.underscore}_id".to_sym
  end

  def primary_key
    @options[:primary_key] || :id
  end

  def class_name
    @options[:class_name] || "#{@name}".singularize.camelcase
  end

end

module Associatable


  def belongs_to(name, options = {})
    options = BelongsToOptions.new(name, options)
    define_method(name) do
      options.model_class.where(
        options.primary_key => self.send(options.foreign_key)
      ).first
    end
    @assoc_options = { name => options }
    # e.g. Human where(:id => 3) where 3 is the owner_id given by the cat
  end

  def has_many(name, options = {})
    options = HasManyOptions.new(name, self.to_s, options)
    define_method(name) do
      options.model_class.where(
      options.foreign_key => self.send(options.primary_key)
      )
    end
    @assoc_options = { name => options }
    # e.g. Cats where(:owner_id => 3) where 3 is the id given by the human
  end

  def assoc_options
    @assoc_options ||= {}
  end
end

class SQLObject
  extend Associatable
end
