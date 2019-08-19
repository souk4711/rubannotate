class CreateArticles < ActiveRecord::Migration[5.1]
  def change
    create_table :articles do |t|
      t.references :author, foreign_key: { to_table: 'users' }, comment: '作成者'
      t.text :content, comment: 'コンテンツ'
    end
  end
end
