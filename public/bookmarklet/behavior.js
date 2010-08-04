var FLB = {
  options: {
    server: "http://0.0.0.0:3000",
  },
  init: function (http) {
    http.open("GET", this.options.server + "/tips/new.js", true);
    http.onreadystatechange = this.get_token(http);
    http.send();
  },
  get_http: function () {
    return (window.XMLHttpRequest)? new XMLHttpRequest(): new ActiveXObject("MSXML2.XMLHTTP");
  },
  tip_page: function (token, http) {
  
    var url = "" + window.location
    var tip_uri = url.split("?uri=")[1].split("&title=")[0];
    console.debug(tip_uri)

    var tip_title = url.split("&title=")[1];
    console.debug(tip_title);
    
    http.open("POST", this.options.server + "/tips", true);
    http.setRequestHeader("Content-type", "application/x-www-form-urlencoded; charset=UTF-8");

    http.onreadystatechange = this.tip_response(http);
    
    var post = {
      authenticity_token: token,
      title: tip_title,
      "tip[uri]": tip_uri
    }
    http.send($.param(post) );
  },
  get_token: function (http) {
    return function() {
      if(http.readyState == 4){
        switch(http.status){
          case 200:
            FLB.tip_page(http.responseText, FLB.get_http());
            return 200;
            break;
          case 401:
            window.open(FLB.options.server + "/login");
            return 401;
            break;
          default:
            FLB.notify_fan("Unable to retrieve server token for tip", http.status);
            return -1;
            break;
        }
      }
    }
  },
  tip_response: function (http) {
    return function(){
      if(http.readyState == 4) {
        switch(http.status){
          case 200:
            FLB.notify_fan(http.responseText, 200);
            return 200;
            break;
          case 401:
            window.open(FLB.options.server + "/login");
            return 401;
            break;
          case 402:
            window.open(FLB.options.server + "/user/fund");
            return 402;
            break;
          case 404:
            FLB.notify_fan("Something is awry. The tipping service is not available", 404);
            return 404;
            break;
          case 422:
            FLB.notify_fan("The authenticity token has failed. Someone, somewhere will pay for this", 422);
            return 422;
            break;
          case 500:
            FLB.notify_fan("The weave server may be having emotional issues, it was unable to complete your tip", http.status);
            return 500;
            break;
          default:
            FLB.notify_fan("Somehting has gone horribly wrong with your tip. \n \n Pray for it's soul", http.status);
            return -1;
            break;
        }
      }
    };
  },
  notify_fan: function (notice, status_code) {
    var div = document.createElement("div");
    div.setAttribute('id', 'flb');
    document.body.appendChild(div);
    div.innerHTML= "<h3>" + notice + "</h3><p> status code: " + status_code + "</p>";

  }
};
FLB.init(FLB.get_http());

