json.array!(@pages) do |json, page|
  json.id page.id
  json.tip_count page.tips_count
  json.title page.title
  json.url page.url
  json.thumbnail_url page.thumbnail
  json.date page.updated_at.to_date
end