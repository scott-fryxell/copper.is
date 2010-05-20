require("spec_helper.js");
require("../../app/views/tips/new.js.erb");

Screw.Unit(function () {
  after(function () { $('#flbNotification').remove(); });

  describe("The notification script returned by the tip controller", function () {
    it("is present", function () {
      expect(flb.notify).to_not(be_undefined);
    });

    it("creates an iframe for notification", function () {
      expect(flb.notify()).to(be_undefined);
      expect($('#flbNotification').length).to(equal, 1);
    });

    it("sets the notification iframe to be 60 pixels wide", function () {
      expect(flb.notify()).to(be_undefined);
      expect($('#flbNotification').attr('width')).to(equal, '60px');
    });

    it("sets the notification iframe to be 60 pixels tall", function () {
      expect(flb.notify()).to(be_undefined);
      expect($('#flbNotification').attr('height')).to(equal, '60px');
    });
  });
});
