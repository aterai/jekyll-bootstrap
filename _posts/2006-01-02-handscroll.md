---
layout: post
category: swing
folder: HandScroll
title: JScrollPaneのViewportをマウスで掴んでスクロール
tags: [JScrollPane, JViewport, MouseListener, MouseMotionListener, JLabel]
author: aterai
pubdate: 2006-01-02T06:45:45+09:00
description: JScrollPaneの窓の中をマウスで掴んで画像をスクロールします。
image: https://lh6.googleusercontent.com/_9Z4BYR88imo/TQTNqjajfcI/AAAAAAAAAbI/Km-h7tWdYOo/s800/HandScroll.png
hreflang:
    href: https://java-swing-tips.blogspot.com/2009/03/mouse-dragging-viewport-scroll.html
    lang: en
comments: true
---
## 概要
`JScrollPane`の窓の中をマウスで掴んで画像をスクロールします。

{% download https://lh6.googleusercontent.com/_9Z4BYR88imo/TQTNqjajfcI/AAAAAAAAAbI/Km-h7tWdYOo/s800/HandScroll.png %}

## サンプルコード
<pre class="prettyprint"><code>class HandScrollListener extends MouseAdapter {
  private final Cursor defCursor = Cursor.getDefaultCursor();
  private final Cursor hndCursor = Cursor.getPredefinedCursor(Cursor.HAND_CURSOR);
  private final Point pp = new Point();
  @Override public void mouseDragged(MouseEvent e) {
    JViewport vport = (JViewport) e.getComponent();
    Point cp = e.getPoint();
    Point vp = vport.getViewPosition();
           //= SwingUtilities.convertPoint(vport, 0, 0, label);
    vp.translate(pp.x - cp.x, pp.y - cp.y);
    //if (r1.isSelected()) {
    label.scrollRectToVisible(new Rectangle(vp, vport.getSize()));
    //} else {
    //  vport.setViewPosition(vp);
    //}
    pp.setLocation(cp);
  }
  @Override public void mousePressed(MouseEvent e) {
    e.getComponent().setCursor(hndCursor);
    pp.setLocation(e.getPoint());
  }
  @Override public void mouseReleased(MouseEvent e) {
    e.getComponent().setCursor(defCursor);
  }
}
</code></pre>

## 解説
`JViewport`の原点(左上)をマウスの移動に応じて変更し、`JComponent#scrollRectToVisible`メソッドの引数として使用して覗き窓のスクロールを行っています。

- `JComponent#scrollRectToVisible(...)`ではなく`JViewport#setViewPosition(Point)`を使用すると、内部コンポーネントの外側に移動可能

<!-- dummy comment line for breaking list -->

## 参考リンク
- [JScrollPaneのオートスクロール](https://ateraimemo.com/Swing/AutoScroll.html)
- [2000ピクセル以上のフリー写真素材集](http://sozai-free.com/)
    - 猫の写真を引用
- [JDK-6333318 JViewPort.scrollRectToVisible( Rectangle cr ) doesn't scroll if cr left or above - Java Bug System](https://bugs.openjdk.java.net/browse/JDK-6333318)
    - `JDK 1.7.0`から、`JViewport#setViewPosition(Point)`などで左上外部に移動不可になっている
    - `Java 11`でこの動作は修正される？ `JScrollPane`ではなく`ScrollPane`で無関係？
        - [JDK-8195738 scroll position in ScrollPane is reset after calling validate() - Java Bug System](https://bugs.openjdk.java.net/browse/JDK-8195738)
- [JScrollPaneでキネティックスクロール](https://ateraimemo.com/Swing/KineticScrolling.html)
- [JTreeの余白をドラッグしてスクロール](https://ateraimemo.com/Swing/TreeDragScroll.html)

<!-- dummy comment line for breaking list -->

## コメント
- つかんで移動ということですが、移動方向が逆の気がします。 -- *名無し* 2006-02-25 (土) 01:24:46
    - ご指摘ありがとうございます。確かに逆ですね。画像を掴んでというより、スクロールバーを掴んでみたいな動きになってました。修正しておきます。 -- *aterai* 2006-02-25 (土) 03:33:50
- `SwingUtilities.convertPoint`の代わりに、`vport.getViewPosition()`を使用するように変更。スクリーンショットの更新。 -- *aterai* 2009-01-19 (Mon) 16:58:27
- `JDK 1.7.0`では、`JViewport#setViewPosition(Point)`を使って~~右下~~左上外部に移動できなくなっている。`Heavyweight`と`Lightweight`コンポーネントが混在しても問題ないようにするために、内部で`revalidate()`しているのが原因？ このサンプルでは`Lightweight`コンポーネントしか使用しないので、`revalidate()`しないように対応。 -- *aterai* 2011-10-03 (月) 18:03:55
- サンプルほしい --  2013-05-11 (土) 03:30:34
    - ページ上部にソースコードなどへのリンクがあるので、使ってみてください。上げ忘れてるとかメンテ中などでなければダウンロードできると思います。 -- *aterai* 2013-05-13 (月) 20:08:18

<!-- dummy comment line for breaking list -->
