require("spec_helper.js");
require("../../public/behavior.js");

Screw.Unit(function (){
  describe("homepage", function(){

    describe("call to action", function () {
      it("should minimize when the guest clicks the x", function () {
        $('body > section > header > span').click();
        expect($("body > section > header.minimized").size()).to(equal, 1);
      });

      it("should set a cookie to minimize itself after the first viewing");

      it("should only display for users who are not logged in");
    });

    describe("search and sorting", function () {
      it("should show 2 columns of tipped items sorted by trending");

      it("should poll the server for articles based on the sort selection");
    });
  })
});