class CreateTraffics < ActiveRecord::Migration[5.0]
  def change
    create_table :traffics do |t|

      t.timestamps
    end
  end
end
