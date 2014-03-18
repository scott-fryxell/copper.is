# provider="twitter"
# username = "brokenbydawn"
# onboard_url = "<%=Copper::Application.config.hostname%>/#{provider}/#{username}"
# $("#twitter").click ->
#   href = "https://twitter.com/intent/tweet?source=webclient&hashtags=tipping&url=#{onboard_url}"
#   $(this).attr('href', href)

# $("#facebook").click ->
#   FB.init({appId: "<%=Copper::Application.config.facebook_appid%>", status: true, cookie: true});
#   obj =
#     method: 'feed',
#     redirect_uri: '<%=Copper::Application.config.hostname%>',
#     link: document.getItems('tips')[0].url
#   FB.ui(obj)

# $("#tumblr_button_abc123").click(function(){
#   href = "http://www.tumblr.com/share/link?url=#{onboard_url}&name=#{author}&tags=copper_is";
#   $(this).attr('href', href)
# .src = "http://api.twitter.com/1/users/profile_image/" + txtBox.value;

$(document).on "load.authors_index", ->
  # $("[itemscope][type=authors]").each ->
    # # get the username
    # username = document.items[$(@).attr('itemid')].username
    # $(@).find('figure > img').attr('src', "http://api.twitter.com/1/users/profile_image/#{username}.png")
