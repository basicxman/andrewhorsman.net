class CreatePreviews < ActiveRecord::Migration
  def change
    create_table :previews do |t|
      t.integer :article_id
      t.string :hash_id

      t.timestamps
    end
  end
end
