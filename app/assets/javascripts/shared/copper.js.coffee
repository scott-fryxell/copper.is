document.copper = 
  tip_amount_options: [
                       5,10,25
                       50,75,100
                       200,300,500
                       1000,1500,2000
                      ]
  format_cents_to_dollars:  (property_name) ->
    $("*[itemprop=#{property_name}]").not('input').not('select').each ->
      cents = $(@).text().trim()
      $(@).text document.copper.cents_to_dollars(cents)
  cents_to_dollars: (cents) ->
    dollars = (parseFloat(cents) / 100.00)
    dollars += '0' if dollars is 0.5 or dollars is 0.1
    return dollars
  get_author_image: ->
    pic
    for author in document.copper.me.authors
      if author.provider is 'facebook' and author.token
        pic = "https://graph.facebook.com/#{author.uid}/picture?type=square"
      if author.provider is 'twitter'
        pic = "https://api.twitter.com/1/users/profile_image?id=#{author.uid}&size=bigger"
      if author.provider is 'google'
        pic = "https://plus.google.com/s2/photos/profile/#{author.uid}"
    pic
    