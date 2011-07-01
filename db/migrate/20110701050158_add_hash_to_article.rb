class AddHashToArticle < ActiveRecord::Migration
  def change
    add_column :articles, :hash, :string
  end
end
