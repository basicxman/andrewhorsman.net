class CreateReadingItems < ActiveRecord::Migration
  def change
    create_table :reading_items do |t|
      t.string :link
      t.string :name
      t.integer :rating

      t.timestamps
    end
  end
end
