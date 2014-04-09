require 'sequel'

class URLRepository
  def initialize(db)
    @urls = db[:urls]
    @id_count = 1
  end

  def add_url(url, short_url = "")
    short_url.empty? ? id = @id_count.to_s : id = short_url
    @urls.insert({url: url, short_url: id, count: 0})
    @id_count += 1
    id
  end

  def get_url(id)
    count = @urls[:short_url => id][:count]
    @urls.where(:short_url => id).update({:count => count + 1})
    @urls[:short_url => id][:url]
  end

  def get_count(id)
    @urls[:short_url => id][:count]
  end

  def vanity_taken?(id)
    !@urls[:short_url => id].nil?
  end

  def get_stats(id, base_url)
    {
      :url => @urls[:short_url => id][:url],
      :short_url => "#{base_url}/#{id}",
      :count => @urls[:short_url => id][:count]
    }
  end
end