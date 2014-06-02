module ScopeOperators
  def or(other)
    left = arel.constraints.reduce(:and)
    right = other.arel.constraints.reduce(:and)
    scope = merge(other)
    scope.where_values = [left.or(right)]
    scope
  end
<<<<<<< HEAD
  alias_method :|, :or
=======
>>>>>>> ed9798a432c3a7259c7855445cf8d4dee8f8c232

  def not(other)
    left = arel.constraints.reduce(:and)
    right = other.arel.constraints.reduce(:and)
    scope = merge(other)
    scope.where_values = [left, right.not]
    scope
  end
<<<<<<< HEAD
  alias_method :-, :not
=======

>>>>>>> ed9798a432c3a7259c7855445cf8d4dee8f8c232

  def and(*args)
    merge(*args)
  end
  alias_method :&, :and
end

ActiveSupport.on_load :active_record do
  ActiveRecord::Relation.send(:include, ScopeOperators)
end