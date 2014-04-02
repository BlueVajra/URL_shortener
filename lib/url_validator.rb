require_relative '../lib/bad_words'

class URLvalidator
  def initialize(url, vanity_url="")
    @url = url
    vanity_url != "" ? @vanity_url = vanity_url : @vanity_url = nil
    @message = nil
  end

  def is_valid?
    if !is_not_empty?
      @message = "The URL cannot be blank."
      false
    elsif !is_format_valid?
      @message = "#{@url} is not a valid URL."
      false
    elsif  @vanity_url != nil
      if !vanity_length_acceptable?
        @message = "Vanity url cannot be more than 12 characters"
        false
      elsif !vanity_only_letters?
        @message = "Vanity must contain only letters"
        false
      elsif !vanity_is_clean?
        @message = "Vanity url cannot have profanity"
        false
      else
        true
      end
    else
      true
    end
  end

  def error_message
    is_valid?
    @message
  end

  def is_not_empty?
    !@url.empty?
  end

  def is_format_valid?
    if @url =~ /^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(([0-9]{1,5})?\/.*)?$/ix
      return true
    else
      return false
    end
  end

  def vanity_length_acceptable?
    @vanity_url.length <= 12
  end

  def vanity_only_letters?
    if @vanity_url.match (/[^A-Za-z]/)
      false
    else
      true
    end
  end

  def vanity_is_clean?
    !Badwords.new.has_profanity? (@vanity_url)
  end


end