$('body > section > details > summary').live("click.display", function (event){
  $('body > section > details[open=open]').attr('open', 'closed');
  $('body > section > details > section > details > summary').attr('open', 'closed');
  $(this).parent().attr('open', 'open');
});


function recieve_feed(json){
  feed = $(json)[0].value.items[0];
  $('body > header').append('<img src="' + feed.logo + '" />');
  $('body > footer').append('<img src="' + feed.icon + '" />');
  $(feed.entry).each(function (){

    var details = $(document.createElement("details")).data(this);

    var time = $(document.createElement("time"))
             .attr('datetime', this.published )
             .text(jQuery.timeago( this.published.slice(0,10) ));

    var summary = $( document.createElement("summary") )
                .append('<h2>' + this.title + '</h2>')
                .append(time)
                .bind('click.add_details', add_details)
                .bind('click.add_aside', add_aside);

    $('body > section ').append($(details).append(summary));
  });
  $('body > section > details:first-child > summary').click();
}
function add_details(event){

  var details = $( document.createElement("details") )
              .data( $(this).parent().data().format )
              .attr('itemprop', 'format')
              .attr('open', 'closed')
              .append('<summary>Format Details</summary>')
              .bind('click.add_format', add_format);

  var section = $( document.createElement("section"))
              .append(details);

  $(this).parent().append(section)
  $(this).unbind("click.add_details");

};
function add_aside(event){

  var img = $(document.createElement("img"))
          .attr('src', $(this).parent().data()['media:thumbnail'].url);

  var dl = $( document.createElement("dl") )
         .append("<dt>Author</dt> <dd itemprop='author'>" + $(this).parent().data().author.name + '</dd>')
         .append("<dt>Rights</dt> <dd itemprop='rights'>" + $(this).parent().data().rights + '</dd>');

  var aside = $(document.createElement("aside"))
            .append(img)
            .append('<a href="'+ $(this).parent().data().link[1].href +'">Download</a>')
            .append(dl)
            .append('<article>' + $(this).parent().data().content.content + '</article>');

  $(this).parent().append(aside);
  $(this).unbind("click.add_aside");
};
function add_format(event){
  format = $(this).data()

  var dl = $( document.createElement("dl") )
         .append("<dt>duration</dt> <dd itemprop='duration'>" + format.duration + '</dd>')
         .append("<dt>Size</dt> <dd itemprop='size'>" + format.size + '</dd>')
         .append("<dt>Aspect Ratio</dt> <dd itemprop='pixel_aspect_ratio'>" + format.pixel_aspect_ratio + '</dd>')
         .append("<dt>Width</dt> <dd itemprop='width'>" + format.width + '</dd>')
         .append("<dt>Height</dt> <dd itemprop='height'>" + format.height + '</dd>')
         .append("<dt>Codec</dt> <dd itemprop='video_codec'>" + format.video_codec + '</dd>');

  $(this).append(dl);
  $(this).unbind("click.add_format");
};
