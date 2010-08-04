require("spec_helper.js");
require("../../public/login_register/behavior.js");

Screw.Unit(function (){
  
  describe("Registration process", function(){
    it("should change the login button to 'Create account' when creating a new account", function() {
      flb.onLoad();
      $("#registered_no").change();
      expect( $('#submit').attr("value") ).to(equal,"Create Account" );
    });
    
  })
});

