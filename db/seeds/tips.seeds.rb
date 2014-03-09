after :users do
  Page.reset_column_information
  puts('creating tips')
  scott = User.find_by_email('scott@copper.is')
  scott.tip(url:'http://www.nytimes.com/2014/03/09/opinion/sunday/can-we-learn-about-privacy-from-porn-stars.html')
  scott.tip(url:'http://www.redbullmusicacademy.com/magazine/razormaid-feature')
  scott.tip(url:'http://yourslownewsday.com/okay-the-google-glass-lady-needs-to-zip-it')
  scott.save
end
