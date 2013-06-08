class Me
  constructor: ->
    jQuery.ajax
      url:'/users/me.json',
      dataType:'json',
      success: (data) =>
        document.me = data;
        Item.update_page document.me
        # if document.me.id is mixpanel.get_distinct_id()
          # console.debug('setting identity')
          # mixpanel.identify(document.me.id)
        # else
          # console.debug('registering new user')
          # mixpanel.alias document.me.id
          # mixpanel.people.set
          #   "$email": document.me.email
          #   "$created": document.me.created_at
          #   "$last_login": new Date()
          #   "$name": document.me.name
          #   "user_id": document.me.id
          #   "tip_preference_in_cents": document.me.tip_preference_in_cents
          #   "share_on_facebook": document.me.share_on_facebook

        $('img.author').attr 'src', @.pic()
        if @.is_admin()
          $('body').addClass("admin")

          $('#admin > img.toggle').click ->
            $('#admin').toggleClass('hide')

        if @.is_fan()
          $('body').addClass("fan")

        $(document).trigger "me.#{$('body').attr('id')}"

      statusCode:
        401:->
          $('body').addClass("guest")
          $(document).trigger "guest.#{$('body').attr('id')}"

  is_admin: ->
    if document.me
      for role in document.me.roles
        if role.name is 'Admin'
          return true

    return false

  is_fan: ->
    if document.me
      for role in document.me.roles
        if role.name is 'Fan'
          return true
    return false

  pic: ->
    pic
    for author in document.me.authors
      if author.provider is 'facebook' and author.token
        pic = "https://graph.facebook.com/#{author.uid}/picture?type=square"
        return pic
      if author.provider is 'twitter'
        pic = "https://api.twitter.com/1/users/profile_image?id=#{author.uid}&size=bigger"
      if author.provider is 'google'
        pic = "https://plus.google.com/s2/photos/profile/#{author.uid}"
    pic

  save: ->
    jQuery.ajax
      dataType:'json'
      url: '/users/me.json'
      type: 'put'
      data: jQuery.param document.me

$(document).ready ->
  new Me()