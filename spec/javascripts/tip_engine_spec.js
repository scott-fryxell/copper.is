require("spec_helper.js");
require("../../public/behavior/tip_engine.js");

Screw.Unit(function () {

  describe("when fetching the authenticity token from the server", function () {

    it("get a token from the server", function () {
      var h = mock();
      h.readyState = 4;
      h.status = 200;
      h.responseText = "this_is_an_authentic_token"

      mock(FLB).should_receive("tip_page").exactly('once');

      var get_handler = FLB.get_token(h);
      expect(get_handler()).to(equal, 200);
    });

    it("should redirect to login if the user is unauthorized", function () {
      var h = mock();
      h.readyState = 4;
      h.status = 401;

      mock(window).should_receive("open").exactly('once').with_arguments("http://0.0.0.0:3000/login");

      var get_handler = FLB.get_token(h);
      expect(get_handler()).to(equal, 401);
    });

    it("should notify the fan of server errors", function () {
      var h = mock();
      h.readyState = 4;
      h.status = 500;

      mock(FLB).should_receive("notify_fan").exactly("once").with_arguments("Unable to retrieve server token for tip", 500);

      var get_handler = FLB.get_token(h);
      expect(get_handler()).to(equal, -1);
    });

    describe("when we succesfully fetch a token",function () {

      it("should submit the tip request", function () {
        var h = mock();
        h.readyState = 4;
        h.status = 200;
        h.responseText = "successfull tip message!!!";

        mock(FLB).should_receive("notify_fan").exactly('once').with_arguments("successfull tip message!!!", 200);

        var get_handler = FLB.tip_response(h);
        expect(get_handler()).to(equal, 200);
      });

      it("should redirect to login if the user is unauthorized", function () {
        var h = mock();
        h.readyState = 4;
        h.status = 401;

        mock(window).should_receive("open").exactly('once').with_arguments("http://0.0.0.0:3000/login");

        var get_handler = FLB.tip_response(h);
        expect(get_handler()).to(equal, 401);
      });

      it("should redirect to fund page if the user's tip jar is empty", function () {
        var h = mock();
        h.readyState = 4;
        h.status = 402;

        mock(window).should_receive("open").exactly('once').with_arguments("http://0.0.0.0:3000/user/fund");
        var get_handler = FLB.tip_response(h);
        expect(get_handler()).to(equal, 402);
      });

      it("should notify the fan if the tipping service is unavailable", function () {
        var h = mock();
        h.readyState = 4;
        h.status = 404;

        mock(FLB).should_receive("notify_fan").exactly("once").with_arguments("Something is awry. The tipping service is not available", 404);

        var get_handler = FLB.tip_response(h);
        expect(get_handler()).to(equal, 404);
      });

      it("should notify the fan if authenticity token gets borked", function () {
        var h = mock();
        h.readyState = 4;
        h.status = 422;

        mock(FLB).should_receive("notify_fan").exactly("once").with_arguments("The authenticity token has failed. Someone, somewhere will pay for this", 422);

        var get_handler = FLB.tip_response(h);
        expect(get_handler()).to(equal, 422);
      });

      it("should notify the fan of a server error", function () {
        var h = mock();
        h.readyState = 4;
        h.status = 500;
        mock(FLB).should_receive("notify_fan").exactly("once").with_arguments("The weave server may be having emotional issues, it was unable to complete your tip", 500);
        var get_handler = FLB.tip_response(h);
        expect(get_handler()).to(equal, 500);
      });

      it("should notify the fan of other errors", function () {
        var h = mock();
        h.readyState = 4;
        h.status = 302;
        mock(FLB).should_receive("notify_fan").exactly("once");
        var get_handler = FLB.tip_response(h);
        expect(get_handler()).to(equal, -1);
      })

    });

    describe("when notifying the user that tipping was successful", function () {
      it("should display a notification to the user", function () {
        var h = mock();
        h.should_receive("open").exactly('once');
        h.should_receive("send").exactly('once');

        h.readyState = 4;
        h.status = 200;
        FLB.init(h);
      });
    });

  });

  describe("The tip response handler", function () {
    after(function () { $('#flb').remove(); });

    it("is present", function () {
      expect(FLB).to_not(be_undefined);
    });

    it("creates a notification div for communicating with the fan", function () {
      FLB.notify_fan("make me a div", 200);
      expect($("#flb")).to(match_selector, "#flb");
    });

  });

});
