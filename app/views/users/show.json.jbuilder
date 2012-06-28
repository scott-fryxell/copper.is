json.(@user, :id, :email, :tip_preference_in_cents)
json.identities @user.identities, :provider, :username, :uid, :token