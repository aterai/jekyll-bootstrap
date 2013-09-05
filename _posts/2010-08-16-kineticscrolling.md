---
layout: post
title: JScrollPaneでキネティックスクロール
category: swing
folder: KineticScrolling
tags: [JScrollPane, Animation, MouseListener, JViewport]
author: aterai
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2010-08-16

## JScrollPaneでキネティックスクロール
`JScrollPane`にキネティックスクロール(慣性スクロール)風の動作をするマウスリスナーを設定します。

- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](http://lh4.ggpht.com/_9Z4BYR88imo/TQTO32D08pI/AAAAAAAAAdE/TpuoGrYo-Q0/s800/KineticScrolling.png)

### サンプルコード
<pre class="prettyprint"><code>class KineticScrollingListener2 extends MouseAdapter {
  private static final int SPEED = 6;
  private static final double D = 0.7;
  private final Cursor dc;
  private final Cursor hc = Cursor.getPredefinedCursor(Cursor.HAND_CURSOR);
  private final javax.swing.Timer inside;
  private final javax.swing.Timer outside;
  private final JComponent label;
  private Point startPt = new Point();
  private Point delta   = new Point();
  private static boolean isInside(JViewport vport, JComponent comp) {
    Point vp = vport.getViewPosition();
    return (vp.x&gt;=0 &amp;&amp; vp.x+vport.getWidth()-comp.getWidth()&lt;=0 &amp;&amp;
            vp.y&gt;=0 &amp;&amp; vp.y+vport.getHeight()-comp.getHeight()&lt;=0);
  }
  public KineticScrollingListener2(JComponent comp) {
    this.label = comp;
    this.dc = comp.getCursor();
    this.inside = new javax.swing.Timer(20, new ActionListener() {
      @Override public void actionPerformed(ActionEvent e) {
        JViewport vport = (JViewport)label.getParent();
        Point vp = vport.getViewPosition();
        //System.out.format("s: %s, %s\n", delta, vp);
        vp.translate(-delta.x, -delta.y);
        vport.setViewPosition(vp);

        if (Math.abs(delta.x)&gt;0 || Math.abs(delta.y)&gt;0) {
          delta.setLocation((int)(delta.x*D), (int)(delta.y*D));
          //Outside
          if (vp.x&lt;0 || vp.x+vport.getWidth()-label.getWidth()&gt;0  ) delta.x = (int)(delta.x*D);
          if (vp.y&lt;0 || vp.y+vport.getHeight()-label.getHeight()&gt;0) delta.y = (int)(delta.y*D);
        } else {
          inside.stop();
          if (!isInside(vport, label)) outside.start();
        }
      }
    });
    this.outside = new javax.swing.Timer(20, new ActionListener() {
      @Override public void actionPerformed(ActionEvent e) {
        JViewport vport = (JViewport)label.getParent();
        Point vp = vport.getViewPosition();
        //System.out.format("r: %s\n", vp);
        if (vp.x&lt;0) vp.x = (int)(vp.x*D);
        if (vp.y&lt;0) vp.y = (int)(vp.y*D);
        if (vp.x+vport.getWidth()-label.getWidth()&gt;0)
          vp.x = (int) (vp.x - (vp.x+vport.getWidth()-label.getWidth())*(1.0-D));
        if (vp.y+vport.getHeight()&gt;label.getHeight())
          vp.y = (int) (vp.y - (vp.y+vport.getHeight()-label.getHeight())*(1.0-D));
        vport.setViewPosition(vp);
        if (isInside(vport, label)) outside.stop();
      }
    });
  }
  @Override public void mousePressed(MouseEvent e) {
    label.setCursor(hc);
    startPt.setLocation(e.getPoint());
    inside.stop();
    outside.stop();
  }
  @Override public void mouseDragged(MouseEvent e) {
    Point pt = e.getPoint();
    JViewport vport = (JViewport)label.getParent();
    Point vp = vport.getViewPosition();
    vp.translate(startPt.x-pt.x, startPt.y-pt.y);
    vport.setViewPosition(vp);
    delta.setLocation(SPEED*(pt.x-startPt.x), SPEED*(pt.y-startPt.y));
    startPt.setLocation(pt);
  }
  @Override public void mouseReleased(MouseEvent e) {
    label.setCursor(dc);
    if (isInside((JViewport)label.getParent(), label)) {
      inside.start();
    } else {
      outside.start();
    }
  }
}
</code></pre>

### 解説
- `scrollRectToVisible`
    - マウスを放したあと、タイマーを起動し、`JComponent#scrollRectToVisible(Rectangle)`メソッドでスクロール
- `setViewPosition`
    - マウスを放したあと、タイマーを起動し、`JViewport#setViewPosition(Point)`メソッドでスクロール
    - `View`である`JLabel`の外で、移動が止まった(またはマウスがリリースされた)場合は、別のタイマーで`JLabel`の縁まで戻る

<!-- dummy comment line for breaking list -->

### 参考リンク
- [JScrollPaneのViewportをマウスで掴んでスクロール](http://terai.xrea.jp/Swing/HandScroll.html)
- [JScrollPaneのオートスクロール](http://terai.xrea.jp/Swing/AutoScroll.html)
- [2000ピクセル以上のフリー写真素材集](http://sozai-free.com/)

<!-- dummy comment line for breaking list -->

### コメント
- 慣性(モーメンタム)スクロール、フリックスクロール(フリック+慣性スクロール？)、・・・でもやっぱり猫の掌スクロールを最初に思い出してしまう。 -- [aterai](http://terai.xrea.jp/aterai.html) 2010-08-16 (月) 13:41:47
- `JDK 1.7.0`では、`JViewport#setViewPosition(Point)`を使って右下外部に移動できなくなっているので、[JScrollPaneのViewportをマウスで掴んでスクロール](http://terai.xrea.jp/Swing/HandScroll.html)と同じ対応をしてソースを更新。 -- [aterai](http://terai.xrea.jp/aterai.html) 2011-10-03 (月) 18:08:23

<!-- dummy comment line for breaking list -->
