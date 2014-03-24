after :users do
  Page.reset_column_information
  puts('creating tips')
  scott = User.find_by_email('scott@copper.is')

  scott.tip(url:'http://www.lrb.co.uk/v36/n04/rebecca-solnit/diary')
  scott.tip(url:'http://tintbrainzane.tumblr.com/?og=1')
  scott.tip(url:'http://vimeo.com/52443205')

  scott.tip(url:'http://www.nytimes.com/2014/02/28/us/politics/obama-will-announce-initiative-to-empower-young-black-men.html')
  scott.tip(url:'http://www.thebolditalic.com/articles/4391-video-time-capsule-4-days-before-the-1906-earthquake')
  scott.tip(url:'http://blog.hull.io/post/47939445232/reconciling-svg-and-icon-fonts')

  scott.tip(url:'http://www.nytimes.com/2014/03/09/opinion/sunday/can-we-learn-about-privacy-from-porn-stars.html')
  scott.tip(url:'http://www.redbullmusicacademy.com/magazine/razormaid-feature')
  scott.tip(url:'http://yourslownewsday.com/okay-the-google-glass-lady-needs-to-zip-it')

end
