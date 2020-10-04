class CreateBlogs < ActiveRecord::Migration[6.0]
  def change
    create_table :blogs do |t|
      t.text :description
      t.string :title
      t.belongs_to :locations
      t.timestamps
    end
  end
end
