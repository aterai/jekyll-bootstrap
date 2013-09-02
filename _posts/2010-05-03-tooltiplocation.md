---
layout: post
title: JToolTipの表示位置
category: swing
folder: ToolTipLocation
tags: [JToolTip, JWindow, MouseListener, MouseMotionListener]
author: aterai
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2010-05-03

## JToolTipの表示位置
`JToolTip`の表示位置がドラッグでマウスカーソルに追従するように設定します。

- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](http://lh5.ggpht.com/_9Z4BYR88imo/TQTVoUwnbfI/AAAAAAAAAn8/lAHqv08RJKA/s800/ToolTipLocation.png)

### サンプルコード
<pre class="prettyprint"><code>@Override public void mouseDragged(MouseEvent me) {
  JComponent c = (JComponent)me.getSource();
  Point p = me.getPoint();
  if(SwingUtilities.isLeftMouseButton(me)) {
    tip.setTipText(String.format("Window(x,y)=(%4d,%4d)", p.x, p.y));
    //tip.revalidate();
    tip.repaint();
    //window.pack();
    window.setLocation(getToolTipLocation(me));
  }else{
    if(popup!=null) popup.hide();
    tip.setTipText(String.format("Popup(x,y)=(%d,%d)", p.x, p.y));
    p = getToolTipLocation(me);
    popup = factory.getPopup(c, tip, p.x, p.y);
    popup.show();
  }
}
</code></pre>

### 解説
- 左クリックしてドラッグ
    - `JWindow`に、`JToolTip`を追加して、`Window#setLocation()`で移動
- 左クリック以外でドラッグ
    - `PopupFactory#getPopup()`で座標を指定した、`Popup`を取得し表示

<!-- dummy comment line for breaking list -->

### 参考リンク
- [JSliderのノブをドラッグ中にToolTipで値を表示](http://terai.xrea.jp/Swing/SliderToolTips.html)

<!-- dummy comment line for breaking list -->

### コメント
