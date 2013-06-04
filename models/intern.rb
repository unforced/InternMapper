class Intern
  include DataMapper::Resource

  # property <name>, <type>
  property :id, Serial
  property :name, String
  property :location, String
  property :extra_info, String

  belongs_to :school, required: false
  belongs_to :company, required: false
end
