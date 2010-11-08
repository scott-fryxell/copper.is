require("spec_helper.js");
require("../../public/behavior/message.en.js");
require("../../public/agent/behavior.js");

Screw.Unit(function (){
  describe("Messaging a user", function (){
    before(function() {
      clean_up();
    });

    it("should notify the user about magic beans", function (){
      var s="body > section.notify > h1";
      $(document).trigger("notify", {"responseText":"<h1>magic beans are good</h1>"});
      /*
        TODO also test that the ui has slide down.
      */
      expect($(s)).to(match_selector, s);
    });

    it("should start a workflow", function (){
      var s = "body > section.workflow > header > .close";
      $("section.workflow").append("<header><h1>header text</h1><span class='close'>x</span></header>")
      $(document).trigger("workflow_start");
      expect($(s)).to(match_selector, s);
    });

    it("should alert the when there is a server error", function (){
      var s ="body > section.alert > ol > li";
      $(document).trigger("alert_start", {"status": 500});
      expect($(s)).to(match_selector, s);
      expect($(s).text()).to(equal, "There was an error with the Weave server. Your tip may not have been saved");
    });

    it("should alert the fan when there is an invalid token", function (){
      var s ="body > section.alert > ol > li"
      expect($(s)).to_not(match_selector, s);
      $(document).trigger("alert_start", {"status": 422});
      expect($(s)).to(match_selector, s);
      expect($(s).text()).to(equal, "A token required for authenticity is missing.");
    });

    it("should alert the fan when a url is not found", function (){
      var s ="body > section.alert > ol > li"
      expect($(s)).to_not(match_selector, s);
      $(document).trigger("alert_start", {"status": 404});
      expect($(s)).to(match_selector, s);
      expect($(s).text()).to(equal, "The the url you are requesting can not be found");
    });

    it("should alert the fan when request method is not allowed", function (){
      var s ="body > section.alert > ol > li"
      expect($(s)).to_not(match_selector, s);
      $(document).trigger("alert_start", {"status": 405});
      expect($(s)).to(match_selector, s);
      expect($(s).text()).to(equal, "a request method the service is trying to access is not available");
    });

    it("should close the alert when the x is clicked", function (){
      var s ="body > section.alert > ol";
      $("section.alert > header > .close").click();
      expect($(s).innerHTML).to(be_null);
    });

    it("should close the workflow when the x is clicked", function(){
      var s ="body > section.workflow > ol";
      $("section.workflow > header > span").click();
      expect($(s).innerHTML).to(be_null);

    });
  });
});

