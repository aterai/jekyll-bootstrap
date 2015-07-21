---
layout: post
category: swing
folder: HorizontalMouseWheel
title: JScrollPaneでMouseWheelによる水平スクロールを行う
tags: [JScrollPane, MouseWheelListener]
author: aterai
pubdate: 2015-03-30T00:02:11+09:00
description: JScrollPaneで水平スクロールを行えるように、その内部のコンポーネントやHorizontalScrollBarにMouseWheelListenerを設定します。
comments: true
---
## 概要
`JScrollPane`で水平スクロールを行えるように、その内部のコンポーネントや`HorizontalScrollBar`に`MouseWheelListener`を設定します。

{% download https://lh4.googleusercontent.com/-4Kw_wS64XRE/VRgM0GXPtuI/AAAAAAAAN1Y/V-bAnSy4pFY/s800/HorizontalMouseWheel.png %}

## サンプルコード
<pre class="prettyprint"><code>label.setBorder(BorderFactory.createTitledBorder("Horizontal scroll: CTRL + Wheel"));
label.addMouseWheelListener(new MouseWheelListener() {
  @Override public void mouseWheelMoved(MouseWheelEvent e) {
    Component c = e.getComponent();
    Container s = SwingUtilities.getAncestorOfClass(JScrollPane.class, c);
    if (Objects.nonNull(s)) {
      JScrollPane sp = (JScrollPane) s;
      JComponent sb = e.isControlDown() ? sp.getHorizontalScrollBar()
                                        : sp.getVerticalScrollBar();
      sb.dispatchEvent(SwingUtilities.convertMouseEvent(c, e, sb));
    }
  }
});

scroll.getVerticalScrollBar().setUnitIncrement(10);

JScrollBar hsb = scroll.getHorizontalScrollBar();
hsb.setUnitIncrement(10);
hsb.addMouseWheelListener(new MouseWheelListener() {
  @Override public void mouseWheelMoved(MouseWheelEvent e) {
    JScrollBar hsb = (JScrollBar) e.getComponent();
    Container p = SwingUtilities.getAncestorOfClass(JScrollPane.class, hsb);
    if (Objects.nonNull(p)) {
      JViewport vport = ((JScrollPane) p).getViewport();
      Point vp = vport.getViewPosition();
      int d = hsb.getUnitIncrement() * e.getWheelRotation();
      vp.translate(d, 0);
      JComponent v = (JComponent) SwingUtilities.getUnwrappedView(vport);
      v.scrollRectToVisible(new Rectangle(vp, vport.getSize()));
    }
  }
});
</code></pre>

## 解説
上記のサンプルでは、`JScrollPane`のビューポートに追加した`JLabel`に`MouseWheelListener`を設定し、<kbd>Ctrl</kbd>キーを押しながらのマウスホイールの場合は、そのイベントを`HorizontalScrollBar`に転送するようにしています。`HorizontalScrollBar`にも`MouseWheelListener`を追加しているので、その上でマウスホイールを回転する場合は、<kbd>Ctrl</kbd>キー無しでも水平スクロールが実行されます。

## 参考リンク
- [#JDK-8033000 No Horizontal Mouse Wheel Support In BasicScrollPaneUI - Java Bug System](https://bugs.openjdk.java.net/browse/JDK-8033000)

<!-- dummy comment line for breaking list -->

## コメント