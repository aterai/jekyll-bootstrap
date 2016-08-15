---
layout: post
category: swing
folder: WheelOverNestedScrollPane
title: MouseWheelEventを親のJScrollPaneに転送する
tags: [JScrollPane, JLayer, MouseWheelEvent]
author: aterai
pubdate: 2014-08-18T00:11:00+09:00
description: JLayerを使って、ネストするJScrollPaneへのMouseWheelEventを転送し、スクロールが継続するように設定します。
image: https://lh4.googleusercontent.com/-Ax3sBgN85bo/U_DD4w3kEjI/AAAAAAAACLg/H0QTGo7hLH4/s800/WheelOverNestedScrollPane.png
hreflang:
    href: http://java-swing-tips.blogspot.com/2014/09/forward-mouse-wheel-scroll-event-in.html
    lang: en
comments: true
---
## 概要
`JLayer`を使って、ネストする`JScrollPane`への`MouseWheelEvent`を転送し、スクロールが継続するように設定します。

{% download https://lh4.googleusercontent.com/-Ax3sBgN85bo/U_DD4w3kEjI/AAAAAAAACLg/H0QTGo7hLH4/s800/WheelOverNestedScrollPane.png %}

## サンプルコード
<pre class="prettyprint"><code>class WheelScrollLayerUI extends LayerUI&lt;JScrollPane&gt; {
  @Override public void installUI(JComponent c) {
    super.installUI(c);
    if (c instanceof JLayer) {
      ((JLayer) c).setLayerEventMask(AWTEvent.MOUSE_WHEEL_EVENT_MASK);
    }
  }
  @Override public void uninstallUI(JComponent c) {
    if (c instanceof JLayer) {
      ((JLayer) c).setLayerEventMask(0);
    }
    super.uninstallUI(c);
  }
  @Override protected void processMouseWheelEvent(
      MouseWheelEvent e, JLayer&lt;? extends JScrollPane&gt; l) {
    Component c = e.getComponent();
    int dir = e.getWheelRotation();
    JScrollPane main = l.getView();
    if (c instanceof JScrollPane &amp;&amp; !c.equals(main)) {
      JScrollPane child = (JScrollPane) c;
      BoundedRangeModel m = child.getVerticalScrollBar().getModel();
      int extent  = m.getExtent();
      int minimum = m.getMinimum();
      int maximum = m.getMaximum();
      int value   = m.getValue();
      if (value + extent &gt;= maximum &amp;&amp; dir &gt; 0 || value &lt;= minimum &amp;&amp; dir &lt; 0) {
        main.dispatchEvent(SwingUtilities.convertMouseEvent(c, e, main));
      }
    }
  }
}
</code></pre>

## 解説
`JScrollPane`がネストしている場合、デフォルトでは子`JScrollPane`内の`MouseWheelEvent`は、親`JScrollPane`には伝搬しません。

上記のサンプルでは、子`JScrollPane`のスクロールバーが最下部にあるなら下方向(最上部なら上方向)の`MouseWheelEvent`は親`JScrollPane`に転送する`LayerUI`を作成し、これを親`JScrollPane`の`JLayer<JScrollPane>`に適用しています。

## 参考リンク
- [JScrollBarが最後までスクロールしたことを確認する](http://ateraimemo.com/Swing/DetectScrollToBottom.html)

<!-- dummy comment line for breaking list -->

## コメント
