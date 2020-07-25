class Paste < ApplicationRecord
  def counter
    ((expired_at - Time.current) / 60).round
  end
  def lang_styled
    language.split("_").join(" ").capitalize
  end
  def expired?
    expired_at.nil?
  end
  def lang?
    language.nil?
  end
  before_save do
    expired_at = expired_at.to_i.minutes.from_now
  end
end
