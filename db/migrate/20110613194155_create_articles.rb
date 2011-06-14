class CreateArticles < ActiveRecord::Migration
  def change
    create_table :articles do |t|
      t.string :title
      t.string :author
      t.text :content
      t.timestamp :published_at
      t.integer :stage
      t.timestamp :last_commit_date

      t.timestamps
    end
  end
end
