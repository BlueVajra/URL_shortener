Sequel.migration {
  up do
    create_table(:urls) do
      primary_key :id
      String :url
      String :short_url
      Integer :count, default: 0
    end
  end
  down do
    drop_table :urls
  end

}