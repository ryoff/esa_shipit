# 記事を検索した上で、それをship itにupdateするだけのscript
#
# 日報をWIPで出してたら、そのまま帰宅して、WIP日報がいっぱい残るのが嫌だったので、帰宅時に叩く想定
require 'esa'
require 'dotenv'
require 'date'

Dotenv.load

class ShipIt
  def initialize
    @client = Esa::Client.new(access_token: ENV['ACCESS_TOKEN'], current_team: ENV['CURRENT_TEAM'])
  end

  def query
    "user:#{ENV['SCREEN_NAME']} in:日報 wip:true created:>#{Date::today.to_s}"
  end

  def ship_it
    response = @client.posts(q: query)

    post = response.body['posts'].first
    return unless post

    @client.update_post(post['number'], wip: false) if post['number']
  end
end

ShipIt.new.ship_it
