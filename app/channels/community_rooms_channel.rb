class CommunityRoomsChannel < ApplicationCable::Channel
  def subscribed
    CommunityRoom.all.each do |community_room|
      stream_from "community_rooms:#{community_room.id}"
    end
  end

  def unsubscribed
    stop_all_streams
  end
end
