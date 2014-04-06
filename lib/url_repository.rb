class URLRepository
  def initialize
    @urls = {}
    @id_count = 1
    @url_host = ""
  end

  def add_url(url, short_url = "")
    short_url.empty? ? id = @id_count.to_s : id = short_url
    @urls[id] = {url: url, count: 0}
    @id_count += 1
    id
  end

  def get_url(id)
    @urls[id][:count] += 1
    @urls[id][:url]
  end

  def get_count(id)
    @urls[id][:count]
  end

  def vanity_taken?(id)
    @urls.has_key?(id)
  end

  def get_stats(id, base_url)
    {
      :url => @urls[id][:url],
      :redirect => "#{base_url}/#{id}",
      :count => @urls[id][:count]
    }
  end
end