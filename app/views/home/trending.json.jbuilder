json.array!(@trending) do |json, page|
  json.id page.id
  json.url page.url
  json.title page.title
  json.tip_count page.tips_count
  json.date page.updated_at.to_date
end