class AddShelf < ActiveRecord::Migration[5.2]
  def change
    add_column :movies, :shelf, :string
  end
end
