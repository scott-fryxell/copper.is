$(document).ready(function(event) {
  $("input[name=amount]").focus();

  $("input[name=amount]").blur(function(event) {
    var tip_stash = this.value;
    if(tip_stash.search(/^[0-9]/)){
      tip_stash = new Number(tip_stash.split("$")[1].valueOf() );
    }else{
      tip_stash = new Number(tip_stash);
    }
    var shakedown =  (tip_stash * 0.07);

    console.debug(shakedown);
    $("label[for=amount] span:nth-child(2)").text(("$" + shakedown).slice(0, 5));

    console.debug(tip_stash + shakedown);
    $("label[for=total] span:nth-child(2)").text("$" + (tip_stash + shakedown));
  });
 
});