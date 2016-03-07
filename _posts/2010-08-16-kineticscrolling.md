---
layout: post
category: swing
folder: KineticScrolling
title: JScrollPaneでキネティックスクロール
tags: [JScrollPane, Animation, MouseListener, JViewport]
author: aterai
pubdate: 2010-08-16T13:34:26+09:00
description: JScrollPaneにキネティックスクロール(慣性スクロール)風の動作をするマウスリスナーを設定します。
hreflang:
    href: http://java-swing-tips.blogspot.com/2010/08/kinetic-scrolling-jscrollpane.html
    lang: en
comments: true
---
## 概要
`JScrollPane`にキネティックスクロール(慣性スクロール)風の動作をするマウスリスナーを設定します。

{% download https://lh4.googleusercontent.com/_9Z4BYR88imo/TQTO32D08pI/AAAAAAAAAdE/TpuoGrYo-Q0/s800/KineticScrolling.png %}

## サンプルコード
<pre class="prettyprint"><code>class KineticScrollingListener2 extends MouseAdapter implements HierarchyListener {
  private static final int SPEED = 4;
  private static final int DELAY = 10;
  private static final double D = 0.8;
  private final JComponent label;
  private final Point startPt = new Point();
  private final Point delta = new Point();
  private final Cursor dc;
  private final Cursor hc = Cursor.getPredefinedCursor(Cursor.HAND_CURSOR);
  private final Timer inside = new Timer(DELAY, new ActionListener() {
    @Override public void actionPerformed(ActionEvent e) {
      JViewport vport = (JViewport) SwingUtilities.getUnwrappedParent(label);
      Point vp = vport.getViewPosition();
      //System.out.format("s: %s, %s%n", delta, vp);
      vp.translate(-delta.x, -delta.y);
      vport.setViewPosition(vp);
      if (Math.abs(delta.x) &gt; 0 || Math.abs(delta.y) &gt; 0) {
        delta.setLocation((int) (delta.x * D), (int) (delta.y * D));
        //Outside
        if (vp.x &lt; 0 || vp.x + vport.getWidth() - label.getWidth() &gt; 0) {
          delta.x = (int) (delta.x * D);
        }
        if (vp.y &lt; 0 || vp.y + vport.getHeight() - label.getHeight() &gt; 0) {
          delta.y = (int) (delta.y * D);
        }
      } else {
        inside.stop();
        if (!isInside(vport, label)) {
          outside.start();
        }
      }
    }
  });
  private final Timer outside = new Timer(DELAY, new ActionListener() {
    @Override public void actionPerformed(ActionEvent e) {
      JViewport vport = (JViewport) SwingUtilities.getUnwrappedParent(label);
      Point vp = vport.getViewPosition();
      //System.out.format("r: %s%n", vp);
      if (vp.x &lt; 0) {
        vp.x = (int) (vp.x * D);
      }
      if (vp.y &lt; 0) {
        vp.y = (int) (vp.y * D);
      }
      if (vp.x + vport.getWidth() - label.getWidth() &gt; 0) {
        vp.x = (int) (vp.x - (vp.x + vport.getWidth() - label.getWidth()) * (1d - D));
      }
      if (vp.y + vport.getHeight() &gt; label.getHeight()) {
        vp.y = (int) (vp.y - (vp.y + vport.getHeight() - label.getHeight()) * (1d - D));
      }
      vport.setViewPosition(vp);
      if (isInside(vport, label)) {
        outside.stop();
      }
    }
  });
  private static boolean isInside(JViewport vport, JComponent comp) {
    Point vp = vport.getViewPosition();
    return vp.x &gt;= 0 &amp;&amp; vp.x + vport.getWidth()  - comp.getWidth()  &lt;= 0
        &amp;&amp; vp.y &gt;= 0 &amp;&amp; vp.y + vport.getHeight() - comp.getHeight() &lt;= 0;
  }
  public KineticScrollingListener2(JComponent comp) {
    super();
    this.label = comp;
    this.dc = comp.getCursor();
  }
  @Override public void mousePressed(MouseEvent e) {
    e.getComponent().setCursor(hc);
    startPt.setLocation(e.getPoint());
    inside.stop();
    outside.stop();
  }
  @Override public void mouseDragged(MouseEvent e) {
    Point pt = e.getPoint();
    JViewport vport = (JViewport) SwingUtilities.getUnwrappedParent(label);
    Point vp = vport.getViewPosition();
    vp.translate(startPt.x - pt.x, startPt.y - pt.y);
    vport.setViewPosition(vp);
    delta.setLocation(SPEED * (pt.x - startPt.x), SPEED * (pt.y - startPt.y));
    startPt.setLocation(pt);
  }
  @Override public void mouseReleased(MouseEvent e) {
    e.getComponent().setCursor(dc);
    JViewport vport = (JViewport) SwingUtilities.getUnwrappedParent(label);
    if (isInside(vport, label)) {
      inside.start();
    } else {
      outside.start();
    }
  }
  @Override public void hierarchyChanged(HierarchyEvent e) {
    Component c = e.getComponent();
    if ((e.getChangeFlags() &amp; HierarchyEvent.DISPLAYABILITY_CHANGED) != 0
        &amp;&amp; !c.isDisplayable()) {
      inside.stop();
      outside.stop();
    }
  }
}
</code></pre>

## 解説
- `scrollRectToVisible`
    - マウスを放したあと、タイマーを起動し、`JComponent#scrollRectToVisible(Rectangle)`メソッドでスクロール
- `setViewPosition`
    - マウスを放したあと、タイマーを起動し、`JViewport#setViewPosition(Point)`メソッドでスクロール
    - `View`である`JLabel`の外で、移動が止まった(またはマウスがリリースされた)場合は、別のタイマーで`JLabel`の縁まで戻る

<!-- dummy comment line for breaking list -->

## 参考リンク
- [JScrollPaneのViewportをマウスで掴んでスクロール](http://ateraimemo.com/Swing/HandScroll.html)
- [JScrollPaneのオートスクロール](http://ateraimemo.com/Swing/AutoScroll.html)
- [2000ピクセル以上のフリー写真素材集](http://sozai-free.com/)

<!-- dummy comment line for breaking list -->

## コメント
- 慣性(モーメンタム)スクロール、フリックスクロール(フリック+慣性スクロール？)、・・・でもやっぱり猫の掌スクロールを最初に思い出してしまう。 -- *aterai* 2010-08-16 (月) 13:41:47
- `JDK 1.7.0`では、`JViewport#setViewPosition(Point)`を使って右下外部に移動できなくなっているので、[JScrollPaneのViewportをマウスで掴んでスクロール](http://ateraimemo.com/Swing/HandScroll.html)と同じ対応をしてソースを更新。 -- *aterai* 2011-10-03 (月) 18:08:23

<!-- dummy comment line for breaking list -->
