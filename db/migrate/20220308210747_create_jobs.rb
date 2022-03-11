class CreateJobs < ActiveRecord::Migration[7.0]
  def change
    create_table :jobs, id: false do |t|
      t.string :account
      t.string :id, primary_key: true
      t.string :elapsed
      t.string :name
      t.string :cluster
      t.string :tres
    end
  end
end
