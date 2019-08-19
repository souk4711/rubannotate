class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :name, comment: 'ユーザー'
      t.string :password_digest, comment: 'パスワード'
      t.string :email, comment: '連絡用メールアドレス'

      t.index 'lower(name)', unique: true
      t.index :email, unique: true
    end
  end
end
