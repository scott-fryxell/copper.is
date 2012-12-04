var copper = {
  format_cents_to_dollars: function (property_name){

    $("*[itemprop="+ property_name +"]").not('input').not('select').each( function (){
       var cents = $(this).text().trim();
       $(this).text(copper.cents_to_dollars(cents));
    })
  },
  cents_to_dollars: function (cents){
    var dollars = (parseFloat(cents) / 100.00)
    if(dollars == 0.5 || dollars == 0.1) {
      dollars = dollars + '0'
    }
    return dollars
  },
  tip_amount_options: ['5','10','25','50','75','100','200','300','500','1000','1500','2000'],
  get_identity_image: function (){
    for(identity in copper.me.identities){
      switch(copper.me.identities[identity].provider){
      case 'facebook':
        return 'https://graph.facebook.com/' + copper.me.identities[identity].uid + '/picture?type=square'
      case 'twitter':
        return 'https://api.twitter.com/1/users/profile_image?id=' + copper.me.identities[identity].uid + '&size=bigger'
      case 'google_oauth2':
        if(copper.me.identities.size == 1){
          return 'https://plus.google.com/s2/photos/profile/' + copper.me.identities[identity].uid  
        }
      }
    }
  }
};