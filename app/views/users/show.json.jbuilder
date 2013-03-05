json.(@user,
  :id, 
  :email,
  :accept_terms,
  :tip_preference_in_cents,
  :stripe_id,
  :payable_to,
  :line1,
  :line2,
  :city,
  :country_code,
  :subregion_code,
  :postal_code
)
json.authors @user.authors, :provider, :username, :uid, :token