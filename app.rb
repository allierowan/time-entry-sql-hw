require 'active_record'
require 'sqlite3'
require 'pry'

ActiveRecord::Base.establish_connection({
  adapter: 'sqlite3',
  database: '74a79d67-time_entries.sqlite3'
  })

class Client < ActiveRecord::Base
  has_many :projects
end

class Comment < ActiveRecord::Base

end

class Developer < ActiveRecord::Base

end

class Group < ActiveRecord::Base

end

class Project < ActiveRecord::Base
  belongs_to :clients
end

class TimeEntry < ActiveRecord::Base

end

binding.pry

puts "All done"

# Find all time entries.
TimeEntry.all

# Find the developer who joined most recently.
Developer.order(created_at: :desc).limit(1)

# Find the number of projects for each client.
Client.left_outer_joins(:projects).group('clients.id').count('projects.id')
