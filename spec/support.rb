class OpenStruct
  def to_json(*args)
    table.to_json
  end
end
