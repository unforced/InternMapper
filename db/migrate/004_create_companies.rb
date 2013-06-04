migration 4, :create_companies do
  up do
    create_table :companies do
      column :id, Integer, :serial => true
      column :name, DataMapper::Property::String, :length => 255
    end
  end

  down do
    drop_table :companies
  end
end
