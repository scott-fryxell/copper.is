class UserSession < Authlogic::Session::Base
  remember_me_for 14.days
  rpx_key RPX_API_KEY


  private

   # map_rpx_data maps additional fields from the RPX response into the user object
   # override this in your session controller to change the field mapping
   # see https://rpxnow.com/docs#profile_data for the definition of available attributes
   #
   def map_rpx_data
     # map core profile data using authlogic indirect column names
     self.attempted_record.send("#{klass.login_field}=", @rpx_data['profile']['preferredUsername'] ) if attempted_record.send(klass.login_field).blank?
     # self.attempted_record.send("#{klass.email_field}=", @rpx_data['profile']['email'] ) if attempted_record.send(klass.email_field).blank?
     self.attempted_record.roles << Role.find_by_name('Patron')
   end

end