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
    %Q|<a href="#{href}" onclick="#{gaq}">Jar file(example.jar)</a>|
  end

  Liquid::Template.register_tag "jar", self
end
