class Dog
    attr_accessor :name, :breed, :id

    def initialize(name:nil, breed:nil, id:nil)
        @name = name
        @breed = breed
        @id = id
        self
    end
    
    def self.create_table
        sql = <<-SQL
        CREATE TABLE IF NOT EXISTS dogs (
            id INTEGER PRIMARY KEY,
            name TEXT,
            breed TEXT
        );
        SQL
        DB[:conn].execute(sql)
    end

    def self.drop_table
        sql = <<-SQL
        DROP TABLE dogs
        ;
        SQL
        DB[:conn].execute(sql)
    end

    def save
        if self.id
          update
        else
          sql_save = <<-SQL
            INSERT INTO dogs (name, breed)
            VALUES (?, ?)
          SQL
          DB[:conn].execute(sql_save, name, breed)
          sql_id = <<-SQL
            SELECT last_insert_rowid() FROM dogs
          SQL
            @id = DB[:conn].execute(sql_id).flatten.first
          end
          self
        end

        def self.create(name:, breed:)
            new_dog = Dog.new
            new_dog.name = name
            new_dog.breed = breed
            new_dog.save
            new_dog
        end

        def self.new_from_db(attribute)
            id, name, breed = attribute[0], attribute[1], attribute[2]
            new_dog = Dog.new
            new_dog.id = id
            new_dog.name = name
            new_dog.breed = breed
            new_dog
        end

        # def self.all

        #     sql = <<-SQL

        #     SELECT * FROM dogs;
        #     SQL
        #     DB[:conn].execute(sql)


        # end

        def self.find_by_name (name)
            sql_y = <<-SQL
              SELECT *
              FROM dogs
              WHERE name = ?
            SQL
            attributes = DB[:conn].execute(sql_y, name).flatten
            new_from_db(attributes)
        end
        
end
