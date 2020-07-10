#!/usr/bin/env ruby

# file: o2html.rb
# description: Transforms custom HTML objects to HTML elements and JavaScript objects. Experimental gem under development.


require 'rexle'
require 'html-to-css'



class O2Html

  class Div
    
    def self.define(attr)
      
      h = {}      
      
      if attr[:scroll] then
        h = {style: 'overflow-y: scroll'}
        attr.delete :scroll
      end
      
      ['div', h]
      
    end    
  end

  class InputBox
    
    def self.define(attr)
      ['input', {type: 'text'}]
    end

    def onenter()
      puts 'onenter'
    end
  end

  class Ajax
    def onresponse()
      puts 'inside onresponse'
    end
    def submit()
      puts 'submit'
    end
  end

  class SrButton
    
    def self.define(attr)
      ['button', {type: 'button'}]
    end
    
    def onresponse()
      puts 'inside onresponse'
    end
  end

  class Sound
  end


  def initialize(s, debug: false)

    @s, @debug = s, debug

    @lookup = {
      div: Div,
      inputbox: InputBox,
      ajax: Ajax,
      sr_button: SrButton,
      sound: Sound
    }

  end
  
  def to_css()
    @css
  end
  
  def to_html()
    
    userdoc = Rexle.new(@s)
    e = userdoc.root.element('body/controls')
    e.delete if e
    doc = Rexle.new(scan2html(Rexle.new(userdoc.xml).to_a))
    
    puts 'before htmltocss: ' + doc.xml.inspect if @debug
    htc = HtmlToCss.new(doc.xml)
    puts 'before to_css' if @debug
    @css = htc.to_css
    puts 'after htmltocss' if @debug
    
    doc.root.each_recursive {|e| e.attributes.delete :style }
    
    head = doc.root.element('head')
    
    if not head then
    
      head = Rexle::Element.new('head')
      doc.root.element('body').insert_before head 
      
    end
    
    style = Rexle::Element.new('style').add_text("\n" + @css + "\n\n")
    head.add style
    
    doc.xml pretty: true
    
  end
  
  def to_js()
  end

  def validate()

    doc = Rexle.new(@s)
    puts doc.root.element('body/script').xml

    a = []
    doc.root.each_recursive do |e|

      type = e.attributes[:type]
      next unless type
      puts 'type: ' + type.inspect
      puts 'e: ' + e.name  if type
      a << "#{e.name} = @lookup[:#{type.to_sym}].new"
    end

    scripts = doc.root.xpath('//script').map(&:text).join
    a << scripts.gsub!(/_on/,'.on')

    a << 'sr1_onresponse("fun")'.gsub(/_on/,'.on')
    eval a.join("\n")
  end
  
  
  private
  
  def scan2html(nodes)

    if nodes.is_a?(Array) and nodes.first.is_a? Array then
      nodes.map do |node|
        scan2html(node)
      end
    elsif nodes.is_a? String
      nodes
    else
      name, attr, val, *remaining = nodes

      if attr and attr[:type] then
        
        puts 'attr: ' + attr.inspect if @debug
        attr ||= {}
        
        attr[:id] = name
        attr[:name] = name        
        name, attr2 = @lookup[attr[:type].to_sym].define(attr)
        
        attr.merge!(attr2)
        
        attr.delete :type        
      end

      r = scan2html(remaining) if remaining and remaining.any?
      [name, attr, val, *r].compact
    end
    
  end  
  
end


if __FILE__ == $0 then

  o2h = O2Html.new(ARGV[0])
  o2h.validate

end
