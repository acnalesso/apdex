require 'sinatra'

get '/' do
  content_type "text/html"
  <<-HTML
    <html>
    <script src="//ajax.googleapis.com/ajax/libs/jquery/1.11.0/jquery.min.js"></script>
    <script>
      $(function() {

        var satisfied  = 0;
        var tolerated  = 0;
        var frustrated = 0;
        var T = 3.0;

        $('body').append('<p>Response Time average is: '+ T +'</p>');

        var response_times = {
          rt0: $('.rt0').val(),
          rt1: $('.rt1').val(),
          rt2: $('.rt2').val(),
          rt3: $('.rt3').val()
        }

        function measureResponseTime(rt){
          var max = 4*T;
          var response_time = parseFloat(rt);
          if(response_time <= T)                         { return satisfied += 1; }
          if(response_time > T && response_time <= max)  { return tolerated += 1; }
          if(response_time > max)                        { return frustrated += 1; }
        }

        function startMeasuring() {
          var responses = parseInt($('.responses input').length);
          for(var i=0; i<responses; i++) {
            var response_time = $('.rt'+i).val();
            measureResponseTime(response_time);
          }
        }

        function generateApdex(){
          startMeasuring();
          var apdex = (satisfied + ( tolerated / 2 )) /  parseInt($('.responses input').length);
          satisfied = 0; tolerated = 0; frustrated = 0;
          return apdex;
        }

        function printApdex() { $('.apdex').html('User experience is: '+ generateApdex()); }

        $('.calc').click(function() { printApdex(); setInterval(printApdex, 1000); });
        $('.add').click(function() { $('.responses').append('<input class=rt'+ parseInt($('.responses input').length) +' type=text/><br />'); });
      });
    </script>

    <div class=responses><input class=rt0 type=text /><br /></div>


    <div class='add' style='display: block; background: blue; color: #fff;'> Add Response </div><br />
    <div class='calc' style='display: block; background: black; color: #fff;'> Generate stats </div><br />
    <p class='apdex' style="color: red;"></p>
  HTML
end
