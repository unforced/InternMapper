migration 5, :add_index_on_ids do
  up do
    create_index(:interns, :school_id)
    create_index(:interns, :company_id)
  end

  down do
  end
end
