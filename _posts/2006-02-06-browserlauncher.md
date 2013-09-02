---
layout: post
title: Browserを起動
category: swing
folder: BrowserLauncher
tags: [JEditorPane, Html, HyperlinkListener]
author: aterai
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2006-02-06

## Browserを起動
ラベル上の`URL`がクリックされると`Browser`を起動します。

- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](http://lh3.ggpht.com/_9Z4BYR88imo/TQTIRWyBTSI/AAAAAAAAASg/pT9GD2uz8BI/s800/BrowserLauncher.png)

### サンプルコード
<pre class="prettyprint"><code>JEditorPane editor = new JEditorPane("text/html",
  "&lt;html&gt;&lt;a href='"+MYSITE+"'&gt;"+MYSITE+"&lt;/a&gt;");
editor.setOpaque(false);
editor.putClientProperty(JEditorPane.HONOR_DISPLAY_PROPERTIES, Boolean.TRUE);
editor.setEditable(false);
editor.addHyperlinkListener(new HyperlinkListener() {
  @Override public void hyperlinkUpdate(HyperlinkEvent e) {
    if(e.getEventType()==HyperlinkEvent.EventType.ACTIVATED) {
      BrowserLauncher.openURL(MYSITE);
    }
  }
});
</code></pre>

### 解説
ブラウザの起動には、[Bare Bones Browser Launch](http://www.centerkey.com/java/browser/)を使用しています。`Mac OS X`, `GNU/Linux`, `Unix`, `Windows XP`に対応しているようです。

`Java SE 6`の新機能である、`java.awt.Desktop`を使用すると、同じようにブラウザやメーラーを起動することができるようになっています([Using the Desktop API in Java SE 6](http://java.sun.com/developer/technicalArticles/J2SE/Desktop/javase6/desktop_api/)、[Desktopでブラウザを起動(JDK 6)](http://terai.xrea.jp/Swing/Desktop.html))。

### 参考リンク
- [Bare Bones Browser Launch for Java • • • Use Default Browser to Open a Web Page from a Swing Application](http://www.centerkey.com/)
- [Java Tips: Free Java Programs, Free Java Applets, Free Java Code, Free Java Tutorials, Free Java Scripts, Java Programming Help](http://www.java-tips.org/content/view/40/2/)

<!-- dummy comment line for breaking list -->

### コメント
