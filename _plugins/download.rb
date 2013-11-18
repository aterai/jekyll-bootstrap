# -*- encoding: utf-8 -*-
class Download < Liquid::Tag
  def initialize(tagName, id, tokens)
    super
    @id = id
  end
  def buttonStyle(c1, c2)
    %Q|style="background:#{c1}" onMouseOver="this.style.background='#{c2}'" onMouseOut="this.style.background='#{c1}'" |
  end
  def render(context)
    #page = context.environments.first["page"]["url"]
    cat  = context.environments.first["page"]["category"].capitalize
    cam  = context.environments.first["page"]["folder"]
    id   = [cat, cam].join("/")

    btn1 = buttonStyle("#F3C0AB", "#FAC1BB")
    btn2 = buttonStyle("#AEC1E3", "#BED1F3")
    btn3 = buttonStyle("#95DFD6", "#A5EFE6")

    href_svn = "http://java-swing-tips.googlecode.com/svn/trunk/#{cam}"
    gaq_svn  = %Q|_gaq.push(['_trackEvent', 'Subversion', 'View', '#{id}']);location.href='#{href_svn}'|

<<"EOS"
<ul>
<li class="button-group">
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
<a href="example.jar" class="button" #{btn1} onclick="_gaq.push(['_trackEvent', 'Jar', 'Download', '#{id}']);location.href='example.jar'">Jar file&nbsp;&nbsp;<span class="button-sub">example.jar</span>&nbsp;&nbsp;<i class="icon-download icon-white" style="vertical-align:middle"></i></a>
</li>
<li class="button-group">
<a href="src.zip" class="button" #{btn2} onclick="_gaq.push(['_trackEvent', 'Source', 'Download', '#{id}']);location.href='src.zip'">Source code&nbsp;&nbsp;<span  class="button-sub">src.zip</span>&nbsp;&nbsp;<i class="icon-download-alt icon-white" style="vertical-align:middle"></i></a>
</li>
<li class="button-group">
<a href="#{href_svn}" class="button" #{btn3} onclick="#{gaq_svn}">Repository&nbsp;&nbsp;<span class="button-sub">svn repository</span>&nbsp;&nbsp;<i class="icon-folder-open icon-white" style="vertical-align:middle"></i></a>
</li>
</ul>
EOS
  end
  Liquid::Template.register_tag "download", self
end
