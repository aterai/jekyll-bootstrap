# -*- encoding: utf-8 -*-
class Svn < Liquid::Tag
  def initialize(tagName, id, tokens)
    super
    #@id = id
  end
  def render(context)
    #page = context.environments.first["page"]["url"]
    cat  = context.environments.first["page"]["category"].capitalize
    cam  = context.environments.first["page"]["folder"]
    id   = [cat, cam].join("/")
    href = "http://java-swing-tips.googlecode.com/svn/trunk/#{cam}"
    gaq  = %Q|_gaq.push(['_trackEvent', 'Subversion', 'View', '#{id}']);location.href='#{href}'|
    %Q|<a href="#{href}" onclick="#{gaq}">Repository(svn repository)</a>|
  end

  Liquid::Template.register_tag "svn", self
end
