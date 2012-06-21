$(document).on("copper:home_index", function (){
  $("a#firefox").click(function(){
    var params = {
      "Foo": { URL: this.href,
               IconURL: this.getAttribute("iconURL"),
               Hash: this.getAttribute("hash"),
               toString: function () { return this.URL; }
      }
    };
    InstallTrigger.install(params);
    return false;
  });
});
