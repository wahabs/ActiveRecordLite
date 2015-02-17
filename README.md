# ActiveRecordLite

Active Record Lite is a simple Object Relational Mapping system, based on [Active Record for Ruby on Rails](http://guides.rubyonrails.org/active_record_basics.html). It implements
Active Record functions such as `has_many`, `belongs_to`, `has_one :through`,
and others.

## Classes

### DB Connection
For testing purposes. Defines a local database connection via the `sqlite3` gem, and
uses the sample database `cats.db`.

### Searchable
Given some results of a database query, Searchable defines a method `where`
that takes in a `params` hash and returns the columns of the query results
for which the query rows and columns match the `params` keys and values.

### Associatable
Given some results of a database query, Associatable defines the following methods:

* `belongs_to`: Takes in a `name` for a new association and an options hash. Maps the calling
table's foreign key column to the associated table's primary key column via a method of the same
name. For example, if a `Cat` class `belongs_to` a `Human` class with the association named `owner`, we can call `myCat.owner`.
* `has_many`: Sets up the reciprocal relation to `belongs_to`, such that a method is defined on
the calling table which returns all rows in the associated table with a foreign key mapping to the caller's primary key. Hence, we may call `myHuman.cats`.
* `has_one_through`: Given that a model `belongs_to` another model and the latter `belongs_to` yet
another model, we can say that the last model has an association to the first model through the
second. The `has_one_through(name, through_name, source_name)` method defines the appropriate method for this association. For example, if a `Human` belongs to a `House`, we can define the method
`Cat#has_one_through(:home, :human, :house)`.

### SQL Object
Defines an the results of a SQL query as an abstracted Ruby object. Extends Searchable and Associatable.
