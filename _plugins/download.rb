# -*- encoding: utf-8 -*-
require 'cgi'

class Download < Liquid::Tag
  def initialize(tagName, url, tokens)
    super
    @url = CGI.escapeHTML(url.strip)
  end
  def render(context)
    cat  = context.environments.first["page"]["category"].capitalize
    cam  = context.environments.first["page"]["folder"]
    id   = [cat, cam].join("/")

    href_svn = "//github.com/aterai/java-swing-tips/tree/master/#{cam}"

<<"EOS"
<div class="row">
<div class="col-md-5 col-xs-12">
<div itemscope="itemscope" itemtype="https://schema.org/Code">
<p><a href="example.jar" class="btn btn-block btn-danger"  download="example.jar" onclick="ga('send', 'event', 'button', 'download', 'example.jar');"><span class="glyphicon glyphicon-save icon-white"></span> Runnable JARファイル <small>example.jar</small></a></p>
<p><a href="src.zip" class="btn btn-block btn-success" download="src.zip"     onclick="ga('send', 'event', 'button', 'download', 'src.zip');"><span class="glyphicon glyphicon-cloud-download icon-white"></span> ソースコード <small>src.zip</small></a></p>
<p><a href="#{href_svn}" class="btn btn-block btn-info" itemprop="codeRepository" onclick="ga('send', 'event', 'button', 'view', 'repository');"><span class="glyphicon glyphicon-import icon-white"></span> リポジトリ <small>repository</small></a></p>
</div>
<p><img src="#{@url}" class="img-responsive" itemprop="image" alt="screenshot"></p>
</div>
<div class="col-md-6 col-md-offset-1 col-xs-12" itemscope="itemscope" itemtype="https://schema.org/WPAdBlock">
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
</div>
EOS
  end
  Liquid::Template.register_tag "download", self
end
