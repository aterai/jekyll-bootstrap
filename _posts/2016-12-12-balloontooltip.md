---
layout: post
category: swing
folder: BalloonToolTip
title: JToolTipの形状を吹き出し風に変更する
tags: [JToolTip, JWindow, HeavyWeightWindow, HierarchyListener, Shape, Area, JList]
author: aterai
pubdate: 2016-12-12T01:24:24+09:00
description: JToolTipの形状を吹き出し風に変更し、JListのセル上にこれを表示します。
image: https://drive.google.com/uc?id=1tL6BwEx2s_gjjZZX3nwBOUAtoslcPXQnrA
hreflang:
    href: https://java-swing-tips.blogspot.com/2016/12/change-shape-of-jtooltip-to-balloon.html
    lang: en
comments: true
---
## 概要
`JToolTip`の形状を吹き出し風に変更し、`JList`のセル上にこれを表示します。

{% download https://drive.google.com/uc?id=1tL6BwEx2s_gjjZZX3nwBOUAtoslcPXQnrA %}

## サンプルコード
<pre class="prettyprint"><code>class BalloonToolTip extends JToolTip {
  private HierarchyListener listener;
  @Override public void updateUI() {
    removeHierarchyListener(listener);
    super.updateUI();
    listener = e -&gt; {
      Component c = e.getComponent();
      if ((e.getChangeFlags() &amp; HierarchyEvent.SHOWING_CHANGED) != 0
          &amp;&amp; c.isShowing()) {
        Window w = SwingUtilities.getWindowAncestor(c);
        if (w instanceof JWindow) {
          ((JWindow) w).setBackground(new Color(0x0, true));
        }
      }
    };
    addHierarchyListener(listener);
    setOpaque(false);
    setBorder(BorderFactory.createEmptyBorder(8, 5, 0, 5));
  }
  @Override public Dimension getPreferredSize() {
    Dimension d = super.getPreferredSize();
    d.height = 28;
    return d;
  }
  @Override public void paintComponent(Graphics g) {
    Shape s = makeBalloonShape();
    Graphics2D g2 = (Graphics2D) g.create();
    g2.setRenderingHint(RenderingHints.KEY_ANTIALIASING,
                        RenderingHints.VALUE_ANTIALIAS_ON);
    g2.setColor(getBackground());
    g2.fill(s);
    g2.setColor(getForeground());
    g2.draw(s);
    g2.dispose();
    super.paintComponent(g);
  }
  private Shape makeBalloonShape() {
    Insets i = getInsets();
    int w = getWidth() - 1;
    int h = getHeight() - 1;
    int v = i.top / 2;
    Polygon triangle = new Polygon();
    triangle.addPoint(i.left + v + v, 0);
    triangle.addPoint(i.left + v, v);
    triangle.addPoint(i.left + v + v + v, v);
    Area area = new Area(new RoundRectangle2D.Float(
        0, v, w, h - i.bottom - v, i.top, i.top));
    area.add(new Area(triangle));
    return area;
  }
}
</code></pre>

## 解説
- `setOpaque(false)`で背景色を描画しない`JToolTop`を作成し、`JToolTop#paintComponent(...)`をオーバーライドして吹き出し風の背景を描画
- `JToolTop`に`HierarchyListener`を追加し、その`JToolTop`が表示状態になった時、親が`JWindow`かどうかを調べてこれを透明に設定
    - `JToolTop`が元`JFrame`外に表示される場合は、`HeavyWeightWindow`(`JWindow`)に配置して表示されるため、`JWindow`を透明にする必要がある
    - `JToolTop`が元`JFrame`内に表示される場合は、その`JFrame`の`JLayeredPane`の`POPUP_LAYER`に`JToolTop`が描画されるので、`setOpaque(false)`な`JToolTop`の背景は描画されない
    - `JWindow#setShape(...)`メソッドでも形状の変更が可能だが、この場合フチを滑らかにすることが難しい
- `JList#createToolTip()`をオーバーライドし、通常の`JToolTip`の代わりに`BalloonToolTip`(上記の`JToolTip`)を作成して返すように設定

<!-- dummy comment line for breaking list -->

<pre class="prettyprint"><code>JList&lt;String&gt; list = new JList&lt;String&gt;(model) {
  @Override public JToolTip createToolTip() {
    JToolTip tip = new BalloonToolTip();
    tip.setComponent(this);
    return tip;
  }
};
</code></pre>

## 参考リンク
- [HierarchyListener (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/java/awt/event/HierarchyListener.html)

<!-- dummy comment line for breaking list -->

## コメント
