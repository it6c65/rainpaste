class CreatePastes < ActiveRecord::Migration[5.2]
  def change
    create_table :pastes do |t|
      t.string :language, limit: 10
      t.string :title, limit: 40
      t.text :content
      t.datetime :expired_at
      t.timestamps
    end
  end
end
