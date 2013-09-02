# -*- encoding: utf-8 -*-
class Src < Liquid::Tag
  def initialize(tagName, id, tokens)
    super
    @id = id
  end
  def render(context)
    #page = context.environments.first["page"]["url"]
    cat  = context.environments.first["page"]["category"].capitalize
    cam  = context.environments.first["page"]["folder"]
    id   = [cat, cam].join("/")
    href = "src.zip"
    gaq  = %Q|_gaq.push(['_trackEvent', 'Source', 'Download', '#{id}']);location.href='#{href}'|
    %Q|<a href="#{href}" onclick="#{gaq}">Source code(src.zip)</a>|
  end

  Liquid::Template.register_tag "src", self
end
