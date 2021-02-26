Introducing the o2html gem


    require 'o2html'


    s = "

    <html>

      <body>

    <input1 type='inputbox'/>
       <chatwindow type='div' scroll='vertical'>
        </chatwindow>

        <ajax1 type='ajax'/>

        <script>

    // this is fun

    </script>
      </body>
    </html>
    "

    o2 = O2Html.new(s, debug: true)
    #o2.validate
    html = o2.to_html
    puts html
    o2.write '/tmp/out.html'

The aim of the o2html gem is to make it easier to build single-page applications by using pre-made HTML components consisting of HTML, CSS, and JavaScript. This is most likely to be a long-term project since there is so many possibilities for making helpful HTML widgets or components which already exist (in some shape of form) on the web.

The idea first emerged when I was building an AJAX enabled web page. The logic is simple enough but trying to remember all the code that is required is difficult unless you're regularly doing it.

## Resources

* o2html https://rubygems.org/gems/o2html

ajax o2html html component widget
