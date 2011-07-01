class ChangeColumnHashFromArticles < ActiveRecord::Migration
  def change
    rename_column :articles, :hash, :preview_hash
  end
end
