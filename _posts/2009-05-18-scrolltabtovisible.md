---
layout: post
title: JTabbedPaneのTabAreaをスクロール
category: swing
folder: ScrollTabToVisible
tags: [JTabbedPane, JViewport, JSlider]
author: aterai
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2009-05-18

## JTabbedPaneのTabAreaをスクロール
`JTabbedPane`の`TabArea`を`JSlider`を使ってスクロールします。

- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](http://lh5.ggpht.com/_9Z4BYR88imo/TQTSn6mtDdI/AAAAAAAAAjE/ja_v92IXLsU/s800/ScrollTabToVisible.png)

### サンプルコード
<pre class="prettyprint"><code>private static void scrollTabAt(JTabbedPane tp, int index) {
  JViewport vp = null;
  for(Component c:tp.getComponents()) {
    if("TabbedPane.scrollableViewport".equals(c.getName())) {
      vp = (JViewport)c;
      break;
    }
  }
  if(vp==null) return;
  final JViewport viewport = vp;
  for(int i=0;i&lt;tp.getTabCount();i++)
    tp.setForegroundAt(i, i==index?Color.RED:Color.BLACK);
  Dimension d = tp.getSize();
  Rectangle r = tp.getBoundsAt(index);
  int gw = (d.width-r.width)/2;
  r.grow(gw, 0);
  viewport.scrollRectToVisible(r);
}
</code></pre>

### 解説
`JTabbedPane#setTabLayoutPolicy(JTabbedPane.SCROLL_TAB_LAYOUT)`とした`JTabbedPane`の`TabArea`は、名前が`TabbedPane.scrollableViewport`な`JViewport`に配置されています。

上記のサンプルでは、この`JViewport`を取得して、`JViewport#scrollRectToVisible(Rectangle)`メソッドを使用し、矢印ボタンをクリックせずに`TabArea`のスクロールを行っています。

### コメント