json.array!(@pages) do |json, page|
  json.id page.id
  json.title page.title
  json.url page.url
  json.thumbnail_url page.thumbnail_url
end