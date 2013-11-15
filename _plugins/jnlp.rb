# -*- encoding: utf-8 -*-
class Jnlp < Liquid::Tag
  def initialize(tagName, id, tokens)
    super
    #@id = id
  end

  def render(context)
    href = "example.jnlp"
    cat  = context.environments.first["page"]["category"].capitalize
    cam  = context.environments.first["page"]["folder"]
    id   = [cat, cam].join("/")
    gaq  = %Q|_gaq.push(['_trackEvent', 'WebStart', 'Launch', '#{id}']);location.href='#{href}'|
    #%Q|<img style="cursor:pointer" width="88" height="23" src="#{icon}" onclick="#{gaq}" onkeypress="location.href='#{href}'" title="Java Web Start" alt="Launch" />|
    #%Q|<a class="jws" href="#{href}" title="Launch Java Web Start" style="display:block;width:90px;height:25px;vertical-align:middle;" onclick="_gaq.push(['_trackEvent', 'WebStart', 'Launch', '$page']);">&#xFEFF;</a>|
    %Q|<a href="#{href}" title="Launch Java Web Start" style="display:block;width:90px;height:25px;vertical-align:middle;" onclick="_gaq.push(['_trackEvent', 'WebStart', 'Launch', '$page']);"><img src="https://lh4.googleusercontent.com/-EEX5hf5sCwc/TRD2KGq73BI/AAAAAAAAAwA/mnDYWjbuezc/s800/webstart.png" width="88" height="23"></a>|
  end

  Liquid::Template.register_tag "jnlp", self
end
