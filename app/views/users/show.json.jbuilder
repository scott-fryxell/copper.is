json.(@user, :id, :email)
json.identities @user.identities, :provider, :username, :uid