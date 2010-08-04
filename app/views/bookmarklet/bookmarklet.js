// javascript:function%20load_flb(url){var%20f=document.createElement(%27iframe%27);f.src=url%20+%20%22?uri=%22%20+%20window.location%20+%20%22&title=%22%20+%20document.getElementsByTagName(%22title%22)[0].innerHTML;document.body.appendChild(f);}load_flb(%22http://0.0.0.0:3000/bookmarklet/worker.html%22);
function load_flb(url){
var f=document.createElement('iframe');
f.src=url + "?uri=" + window.location + "&title=" + document.getElementsByTagName("title")[0].innerHTML;
document.body.appendChild(f);
}
load_flb("http://0.0.0.0:3000/bookmarklet/worker.html");
