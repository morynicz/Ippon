class Club < ActiveRecord::Base
  has_many :club_admins
  after_commit :add_admin, on: :create
  attr_accessor :creator

  def add_admin
    if @creator != nil
      puts "ac test #{@creator.id} #{self.id}"
      ClubAdmin.create(club_id: self.id, user_id: @creator.id) unless ClubAdmin.exists?(club_id: self.id, user_id: @creator.id)
    end
  end
end
