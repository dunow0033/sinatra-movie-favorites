class DropColumns < ActiveRecord::Migration[5.2]
  def change
    remove_column :movies, :director
    remove_column :movies, :rating
    remove_column :movies, :genre
  end
end
