class ChangeColumnStageFromArticles < ActiveRecord::Migration
  def change
    change_table :articles do |t|
      t.change :stage, :integer, :default => 0
    end
  end
end
