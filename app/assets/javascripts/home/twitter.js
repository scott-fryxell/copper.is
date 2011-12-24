new TWTR.Widget({
  version: 2,
  type: 'profile',
  rpp: 2,
  interval: 5000,
  width: 'auto',
  height: 100,
  theme: {
    shell: {
      background: '#fbf6f1',
      color: '#ff0000'
    },
    tweets: {
      background: '#fbf6f1',
      color: '#666666',
      links: '#ff0000'
    }
  },
  features: {
    scrollbar: false,
    loop: false,
    live: true,
    behavior: 'default'
  }
}).render().setUser('dirtywcouch').start();