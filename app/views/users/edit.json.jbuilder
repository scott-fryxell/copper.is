json.(@user,
  :id, 
  :email,
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
json.identities @user.identities, :provider, :username, :uid, :token