class Authors::Google < Author
  include Enqueueable
  include Artist::Desirable::Google

  def url
    "https://plus.google.com/#{self.uid}"
  end

  def self.identity_from_url url
    # http://plus.google.com/110547857076579322423/
    { provicer:'google', uid: URI.parse(url).path().split('/').last, }
  end

  def determine_image
    super do
      unless image
        image = "https://plus.google.com/s2/photos/profile/#{self.uid}"
        save
      end
      image
    end
  end

end
