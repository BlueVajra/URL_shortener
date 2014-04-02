class Datastore

  def initialize
    clear_db
  end

  def add_url(url, vanity_url=nil)
    if vanity_url == nil
      @db[@id] = {url: url, count: 0}
      @id += 1
    else
      @db[vanity_url] = {url: url, count: 0}
    end
  end

  def get_url(id)
    @db[id][:url]
  end

  def clear_db
    @db = {}
    @id = 1
  end

  def get_redirect_url(id)
    @db[id][:count] += 1
    @db[id][:url]
  end

  def get_count(id)
    @db[id][:count]
  end
end