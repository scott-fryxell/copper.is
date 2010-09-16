require("spec_helper.js");
require("../../public/login_register/behavior.js");

Screw.Unit(function (){
  describe("Registration process", function(){
    it("should change the login button to 'Create account' when creating a new account", function() {
      $("#registered_no").change();
      expect( $('#submit').attr("value") ).to(equal,"Create Account" );
    });

    it("should change the login button to 'log in' when logging in to the service", function() {
      $("#registered_yes").change();
      expect( $('#submit').attr("value") ).to(equal,"Log in" );
    });
  })
});

