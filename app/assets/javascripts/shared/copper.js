var copper = {
  format_cents_to_dollars: function(property_name){
    var rate = $("p[itemprop="+ property_name +"]").text().trim()
    rate = (parseFloat(rate) / 100.00)
    if( rate == 0.5 || rate == 0.1){
      rate = rate + '0'
    }
    $("p[itemprop=" + property_name +"]").text(rate)
  },
  get_identity_image: function (){
    for(identity in copper.me.identities){
      switch(copper.me.identities[identity].provider){
      case 'facebook':
        return 'http://graph.facebook.com/' + copper.me.identities[identity].uid + '/picture?type=square'
      case 'twitter':
        return 'https://api.twitter.com/1/users/profile_image?id=' + copper.me.identities[identity].uid + '&size=bigger'
      case 'google_oauth2':
        return 'https://plus.google.com/s2/photos/profile/' + copper.me.identities[identity].uid
      }
    }
  }
};
