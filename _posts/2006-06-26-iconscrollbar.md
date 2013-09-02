---
layout: post
title: ScrollBarの表示を変更
category: swing
folder: IconScrollBar
tags: [JScrollBar]
author: aterai
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2006-06-26

## ScrollBarの表示を変更
`JScrollBar`のバー表示を変更します。

- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](http://lh6.ggpht.com/_9Z4BYR88imo/TQTOPy62F7I/AAAAAAAAAcE/M4J9GIXdfBY/s800/IconScrollBar.png)

### サンプルコード
<pre class="prettyprint"><code>scrollPane.getVerticalScrollBar().setUI(new WindowsScrollBarUI() {
  @Override protected void paintThumb(Graphics g,
                            JComponent c, Rectangle thumbBounds) {
    super.paintThumb(g,c,thumbBounds);
    Graphics2D g2 = (Graphics2D)g;
    g2.setRenderingHint(RenderingHints.KEY_ANTIALIASING,
                RenderingHints.VALUE_ANTIALIAS_ON);
    Color oc = null;
    Color ic = null;
    JScrollBar sb = (JScrollBar)c;
    if (!sb.isEnabled() || thumbBounds.width&gt;thumbBounds.height) {
      return;
    }else if(isDragging) {
      oc = SystemColor.activeCaption.darker();
      ic = SystemColor.inactiveCaptionText.darker();
    }else if(isThumbRollover()) {
      oc = SystemColor.activeCaption.brighter();
      ic = SystemColor.inactiveCaptionText.brighter();
    }else{
      oc = SystemColor.activeCaption;
      ic = SystemColor.inactiveCaptionText;
    }
    paintCircle(g2,thumbBounds,6,oc);
    paintCircle(g2,thumbBounds,10,ic);
  }
  private void paintCircle(Graphics2D g2, Rectangle thumbBounds,
                           int w, Color color) {
    g2.setPaint(color);
    int ww = thumbBounds.width-w;
    g2.fillOval(thumbBounds.x+w/2,
                thumbBounds.y+(thumbBounds.height-ww)/2,
                ww,ww);
  }
});
</code></pre>

### 解説
上記のサンプルでは、`WindowsScrollBarUI`を取得して、垂直スクロールバーに円状のアイコンを表示しています。このため`Windows`では、ドラッグしている状態、カーソルがバー上にあってロールオーバーしている状態、通常の状態でこのアイコンの色が変わります。

スクロールバーの長さが足りない場合、アイコンの表示は行われません。

### コメント
