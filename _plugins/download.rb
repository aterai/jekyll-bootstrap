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
    href_svn = "http://java-swing-tips.googlecode.com/svn/trunk/#{cam}"

<<"EOS"
<div class="row">
<div class="col-md-6 col-xs-12 pull-left">
<p><a href="example.jar" download class="btn btn-block btn-danger">Jar file <small>example.jar</small> <i class="icon-download icon-white" style="vertical-align:middle"></i></a></p>
<p><a href="src.zip" download class="btn btn-block btn-success">Source code <small>src.zip</small> <i class="icon-download-alt icon-white" style="vertical-align:middle"></i></a></p>
<p><a href="#{href_svn}" class="btn btn-block btn-info">Repository <small>svn repository</small> <i class="icon-folder-open icon-white" style="vertical-align:middle"></i></a></p>
<p><img src="#{@url}" alt="screenshot"></p>
</div>
<div class="col-md-6 col-xs-12 pull-right">
<!-- responsive -->
<ins class="adsbygoogle"
     style="display:block"
     data-ad-client="ca-pub-6939179021013694"
     data-ad-slot="1067574330"
     data-ad-format="auto"></ins>
<script>
(adsbygoogle = window.adsbygoogle || []).push({});
</script>
</div>
<div class="clearfix"></div>
</div>
EOS
  end
  Liquid::Template.register_tag "download", self
end
