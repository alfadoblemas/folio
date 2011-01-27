class CreateStateStatuses < ActiveRecord::Migration
  def self.up
     Status.update(1, :state => "draft")
     Status.update(2, :state => "open")
     Status.update(3, :state => "close")
     Status.update(4, :state => "cancel")
     Status.update(5, :state => "due")
  end

  def self.down
  end

end
