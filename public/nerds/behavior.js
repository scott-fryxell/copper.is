$(document).ready(function (event){
  $.getJSON('http://pipes.yahoo.com/pipes/pipe.run',
    {
      "_id":'f42c711ab0e64056fd200b38ad98e102',
      '_render':'json'
    },
    function (json) {
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
  );
});
$('body > section > details > summary').live("click.display", function (event){
  $('body > section > details[open=open]').attr('open', 'closed');
  $(this).parent().attr('open', 'open');
});
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
  console.debug(format);
  var dl = $( document.createElement("dl") )
         .append("<dt>duration</dt> <dd itemprop='duration'>" + format.duration + '</dd>')
         .append("<dt>Size</dt> <dd itemprop='size'>" + format.size + '</dd>')

  $(this).parent().append(dl);
  $(this).unbind("click.add_format");
};

// <details open="closed" itemprop='format'>
//   <summary>Video details</summary>
//   <dl>
//     <dt>Duration</dt> <dd itemprop='duration'>4260.0</dd>
//     <dt>Size</dt> <dd itemprop='size'>733704312.0</dd>
//     <dt>Aspect Ratio</dt> <dd itemprop='pixel_aspect_ratio'>16:9</dd>
//     <dt>Width</dt> <dd itemprop='width'>624</dd>
//     <dt>Height</dt> <dd itemprop='height'>352</dd>
//     <dt>Frame Rate</dt> <dd itemprop='framerate'>25.0</dd>
//     <dt>Video Codec</dt> <dd itemprop='video_codec'>xvid</dd>
//     <dt>Video Bit Rate</dt> <dd itemprop='video_bitrate'>1238.0</dd>
//     <dt>Audio Bitrate</dt> <dd itemprop='audio_bitrate'>128.0</dd>
//     <dt>Sample Rate</dt> <dd itemprop='samplerate'>44100.0</dd>
//     <dt>Audio Codec</dt> <dd itemprop='audio_codec'>null</dd>
//     <dt>Channels</dt> <dd itemprop='channels'>2</dd>
//   </dl>
// </details>
