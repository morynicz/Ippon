class MakeShiroAndAkaNullableInFights < ActiveRecord::Migration
  def change
    change_column_null :fights, :aka_id, true
    change_column_null :fights, :shiro_id, true
  end
end
