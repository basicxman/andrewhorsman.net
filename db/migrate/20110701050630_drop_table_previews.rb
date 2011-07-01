class DropTablePreviews < ActiveRecord::Migration
  def change
    drop_table :previews
  end
end
