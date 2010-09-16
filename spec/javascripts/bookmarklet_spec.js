require("spec_helper.js");
require("../../public/behavior/flb.js");
require("../../public/bookmarklet/behavior.js");

Screw.Unit(function (){
  describe("Tipping a url", function (){

    describe("succsessfuly", function (){
      var notify_count, request_count;
      before(function() {
        FLB.location = window.location + "#/example.com&title=a_title";
        request_count = 0;
        notify_count = 0;
        $.ajax = function (event){
          FLB.tip.authenticity_token = "a_token";
          request_count ++;
        }

        $(document).unbind("notify");
        $(document).bind("notify", function (){
          notify_count++;
        });

      });

      it("should get the URL to be tipped", function (){
        $(document).trigger("tip_determine");
        expect(FLB.tip.uri).to(equal, "example.com");
      });

      it("should get the title for the tip", function (){
        $(document).trigger("tip_determine");
        expect(FLB.tip.title).to(equal, "a_title");
      });

      it("should get a token from the server", function (){
        $(document).trigger("tip_token_get");
        expect(FLB.tip.authenticity_token).to(equal, "a_token");
        expect(request_count).to(equal, 1);
      });

      it("should post a tip to the server", function (){
        $(document).trigger("tip_submit");
        expect(request_count).to(equal, 1);
      });

      it("Should notify the user", function (){
        expect($("section.notify > h1")).to(be_empty);
        expect(notify_count).to(equal, 0);
        $(document).trigger("tip_success", {responseText: "<h1>Your tip was successfull</h1>"});
        expect(notify_count).to(equal, 1);
      });
    });

    describe("when not logged in", function (){
      var workflow_start_count, workflow_end_count, tip_token_count, window_open_count,
          post_count, click_count, submit_count, request_count;
      before(function() {
        clean_up();
        request_count = 0;
        workflow_start_count = 0;
        workflow_end_count = 0;
        post_count = 0;
        click_count = 0;
        submit_count = 0
        notify_count = 0;
        tip_token_count = 0;
        window_open_count = 0;
        var xhr = {
          responseText: "<header><span>X</span><h1>Alert</h1></header><form></form>"
        }

        jQuery.fn.extend({
          load: function (){
            $("section.workflow").append(xhr.responseText);
            request_count++;
            return this;
          },
          click: function(){
            click_count++;
            return this;
          },
          submit: function(){
            submit_count++;
            return this;
          }
        });

        $.post = function (event){
          console.debug("mocking the post");
          post_count++;
          return this;
        }

        $(document).unbind("open");
        $(document).bind("open", function (){
          window_open_count++;
        });
        $(document).unbind("workflow_start");
        $(document).bind("workflow_start", function (){
          workflow_start_count++;
        });

        $(document).unbind("workflow_end");
        $(document).bind("workflow_end", function (){
          workflow_end_count++;
        });

        $(document).unbind("tip_token_get");
        $(document).bind("tip_token_get", function (){
          tip_token_count++;
        });

      });

      it("should load the login form", function (){
        $(document).trigger("login_get");
        expect( $("section.workflow > form") ).to_not(be_empty);
        expect(request_count).to(equal, 1);
      });

      it("should display the login workflow", function (){
        $(document).trigger("login_display");
        expect(workflow_start_count).to(equal, 1);
      });

      it("should close the login form", function (){
        $("section.workflow").append("<header> <h1>display</h1> <span class='close'>X</span>");
        $(document).trigger("login_display");
        expect(click_count).to(equal, 1);
        $("section.workflow > header .close").click();
        expect(click_count).to(equal, 2);
      });

      it("should submit the login form", function (){
        $(document).trigger("login_display");
        expect(submit_count).to(equal, 1);
        $("section.workflow > form").submit();
        expect(submit_count).to(equal, 2);
      });

      it("should post the login form", function (){
        $("section.workflow").append("<form></form/>");

        $(document).trigger("login_submit");
        expect(workflow_end_count).to(equal, 1)
        expect(post_count).to(equal, 1);
      });

      it("should retry the tip after successfull login", function (){
        $(document).trigger("login_success");
        expect(tip_token_count).to(equal, 1);
      });

      it("should open new window to a lost password page",function (){
        expect(window_open_count).to(equal, 0);
        $(document).trigger("lost_password");
        expect(window_open_count).to(equal, 1);
      });

      it("open a link to a new order when the fan is out of funds", function (){
        expect(window_open_count).to(equal, 0);
        $(document).trigger("tip_bundle_empty");
        expect(window_open_count).to(equal, 1);
      });

    });

  });
});
