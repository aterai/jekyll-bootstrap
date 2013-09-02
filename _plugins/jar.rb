# -*- encoding: utf-8 -*-
class Jar < Liquid::Tag
  def initialize(tagName, id, tokens)
    super
    #@id = id
  end
  def render(context)
    #page = context.environments.first["page"]["url"]
    cat  = context.environments.first["page"]["category"].capitalize
    cam  = context.environments.first["page"]["folder"]
    id   = [cat, cam].join("/")
    href = "example.jar"
    gaq  = %Q|_gaq.push(['_trackEvent', 'Jar', 'Download', '#{id}']);location.href='#{href}'|

<<"EOS"
<div class="ad_box">
<!-- xrea, big, 336x280, 09/11/04 -->
<ins class="adsbygoogle"
     style="display:inline-block;width:336px;height:280px"
     data-ad-client="ca-pub-6939179021013694"
     data-ad-slot="9248548235"></ins>
<script>
(adsbygoogle = window.adsbygoogle || []).push({});
</script>
</div>
<a href="#{href}" onclick="#{gaq}">Jar file(example.jar)</a>
EOS

    #%Q|<a href="#{href}" onclick="#{gaq}">Jar file(example.jar)</a>|
  end

  Liquid::Template.register_tag "jar", self
end
