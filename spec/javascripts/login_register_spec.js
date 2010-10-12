require("spec_helper.js");
require("../../public/login_register/behavior.js");

Screw.Unit(function (){
  describe("Registration process", function(){
    it("should change the login button to 'Create Account' when creating a new account", function() {
      $("#registered_no").change();
      expect( $('#submit').attr("value") ).to(equal,"Create Account" );
    });

    it("should change the login button to 'Sign in' when logging in to the service", function() {
      $("#registered_yes").change();
      expect( $('#submit').attr("value") ).to(equal,"Sign in" );
    });
  })
});

