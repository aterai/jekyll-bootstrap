# -*- encoding: utf-8 -*-
class Download < Liquid::Tag
  def initialize(tagName, url, tokens)
    super
    @url = url
  end
  def render(context)
    #page = context.environments.first["page"]["url"]
    cat  = context.environments.first["page"]["category"].capitalize
    cam  = context.environments.first["page"]["folder"]
    id   = [cat, cam].join("/")

#     btn1 = buttonStyle("#F3C0AB", "#FAC1BB")
#     btn2 = buttonStyle("#AEC1E3", "#BED1F3")
#     btn3 = buttonStyle("#95DFD6", "#A5EFE6")

    href_svn = "http://java-swing-tips.googlecode.com/svn/trunk/#{cam}"
    gaq_svn  = %Q|_gaq.push(['_trackEvent', 'Subversion', 'View', '#{id}']);location.href='#{href_svn}'|

<<"EOS"
<div class="row">
<div class="col-md-3 pull-left">
<p><a href="example.jar" class="btn btn-block btn-danger"  onclick="_gaq.push(['_trackEvent', 'Jar', 'Download', '#{id}']);location.href='example.jar'">Jar file&nbsp;&nbsp;<small>example.jar</small>&nbsp;&nbsp;<i class="icon-download icon-white" style="vertical-align:middle"></i></a></p>
<p><a href="src.zip"     class="btn btn-block btn-success" onclick="_gaq.push(['_trackEvent', 'Source', 'Download', '#{id}']);location.href='src.zip'">Source code&nbsp;&nbsp;<small>src.zip</small>&nbsp;&nbsp;<i class="icon-download-alt icon-white" style="vertical-align:middle"></i></a></p>
<p><a href="#{href_svn}" class="btn btn-block btn-info"    onclick="#{gaq_svn}">Repository&nbsp;&nbsp;<small>svn repository</small>&nbsp;&nbsp;<i class="icon-folder-open icon-white" style="vertical-align:middle"></i></a></p>
<p><img src="#{@url}" alt="screenshot"></p>
</div>
<div class="col-md-offset5 pull-right">
<!-- xrea, big, 336x280, 09/11/04 -->
<ins class="adsbygoogle"
     style="display:inline-block;width:336px;height:280px"
     data-ad-client="ca-pub-6939179021013694"
     data-ad-slot="9248548235"></ins>
<script>
(adsbygoogle = window.adsbygoogle || []).push({});
</script>
</div>
<div class="clearfix">&nbsp;</div>
</div>
EOS
  end
  Liquid::Template.register_tag "download", self
end
