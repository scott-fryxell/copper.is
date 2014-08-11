after :users do

  Page.reset_column_information
  puts('creating tips')
  scott = User.find_by(email:'scott@copper.is')

  trending = [
    'http://www.lrb.co.uk/v36/n04/rebecca-solnit/diary',
    'http://vimeo.com/52443205',
    'http://www.nytimes.com/2014/02/28/us/politics/obama-will-announce-initiative-to-empower-young-black-men.html',
    'http://www.thebolditalic.com/articles/4391-video-time-capsule-4-days-before-the-1906-earthquake',
    'http://blog.hull.io/post/47939445232/reconciling-svg-and-icon-fonts',
    'http://www.nytimes.com/2014/03/09/opinion/sunday/can-we-learn-about-privacy-from-porn-stars.html',
    'http://www.redbullmusicacademy.com/magazine/razormaid-feature',
    'http://yourslownewsday.com/okay-the-google-glass-lady-needs-to-zip-it',
    'http://www.nytimes.com/interactive/2014/06/27/world/legacy-of-world-war-i.html'
    'http://www.nytimes.com/2014/08/10/magazine/staking-out-the-great-white-shark.html?src=dayp'
  ]

  for url in trending
    scott.tip(url:url)
    scott.tip(url:url)
  end

  recent = [
    'http://blog.atom.io/2014/03/13/git-integration.html',
    'http://blogs.villagevoice.com/music/2014/08/ask_andrew_wk_right_wing_dad.php',
    'http://www.sfgate.com/bayarea/article/Residential-development-threatens-S-F-s-music-5680418.php',
    'http://www.nytimes.com/2014/08/05/opinion/frank-bruni-plato-and-the-promise-of-college.html',
    'http://www.nytimes.com/2014/08/06/technology/russian-gang-said-to-amass-more-than-a-billion-stolen-internet-credentials.html',
    'http://www.thedailybeast.com/articles/2014/08/03/five-lessons-the-faltering-music-industry-could-learn-from-tv.html',
    'http://www.nytimes.com/2014/08/05/world/europe/buildup-makes-russia-battle-ready-for-ukraine.html',
    'http://www.nytimes.com/2014/08/06/upshot/alarm-on-income-inequality-from-a-mainstream-source.html',
    'http://www.nytimes.com/2014/08/06/upshot/luck-and-a-little-mystery-the-economy-grows-faster-under-democratic-presidents.html',
    'http://dealbook.nytimes.com/2014/08/05/new-strategy-as-tech-giants-transform-into-conglomerates',
    'http://www.newyorker.com/magazine/1940/04/13/the-old-house-at-home',
    'http://www.nytimes.com/2014/08/03/technology/how-facebook-sold-you-krill-oil.html',
    'http://www.html5rocks.com/en/tutorials/security/sandboxed-iframes/',
    'http://www.thedailybeast.com/articles/2014/08/03/five-lessons-the-faltering-music-industry-could-learn-from-tv.html',
    'http://www.vice.com/read/german-cat-breeder-websites-876',
    'http://www.google.com/design/spec/material-design/introduction.html',
    'http://www.broken-links.com/2012/08/14/better-svg-sprites-with-fragment-identifiers/',
    'http://daringfireball.net/'
  ]

  for url in recent
    scott.tip(url:url)
  end

  not_safe_for_work = [
    'http://www.vintagespankings.com/fetish/dianaslip.html',
  ]

  for url in not_safe_for_work
    scott.tip(url:url, nsfw:true)
    scott.tip(url:url)
    scott.tip(url:url)
    scott.tip(url:url)
  end

end
