class AddPageTumbnailUrl < ActiveRecord::Migration
def up
    add_column :pages, :thumbnail_url, :text
    Page.all.each do |page|
      page.thumbnail_url = "http://img.bitpixels.com/getthumbnail?code=59482&size=200&url=#{page.url}"
      page.save
    end
  end

  def down
    remove_column :pages, :thumbnail_url
  end
end
