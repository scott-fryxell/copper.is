json.array!(@tips) do |json, tip|
  json.id tip.id
  json.amount_in_cents tip.amount_in_cents
  json.page tip.page
  json.paid_state tip.paid_state
  json.date tip.updated_at.to_date
end