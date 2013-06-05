var _gaq = _gaq || [];
_gaq.push(['_setAccount', 'UA-30118836-1']);
_gaq.push(['_setDomainName', 'copper.is']);
_gaq.push(['_trackPageview']);
(function() {
  var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
  ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
  var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
})();

// document.ready
$(function() {
  $('body').on('click', 'a[itemprop=url]', function() {
    console.debug('outbound link');
    try { 
      _gaq.push(['_trackEvent', 'Outbound Links', $(this).attr('href')]); 
    } catch(err){}
  });
});