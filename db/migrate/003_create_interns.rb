migration 3, :create_interns do
  up do
    create_table :interns do
      column :id, Integer, :serial => true
      column :name, DataMapper::Property::String, :length => 255
      column :school_id, DataMapper::Property::Integer
      column :company_id, DataMapper::Property::Integer
      column :location, DataMapper::Property::String, :length => 255
      column :extra_info, DataMapper::Property::Text
    end
  end

  down do
    drop_table :interns
  end
end
