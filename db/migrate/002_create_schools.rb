migration 2, :create_schools do
  up do
    create_table :schools do
      column :id, Integer, :serial => true
      column :name, DataMapper::Property::String, :length => 255
    end
  end

  down do
    drop_table :schools
  end
end
