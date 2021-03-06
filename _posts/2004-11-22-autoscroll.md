---
layout: post
category: swing
folder: AutoScroll
title: JScrollPaneのオートスクロール
tags: [JScrollPane, JViewport, JScrollPane, DragAndDrop, Timer, MouseListener, MouseMotionListener]
author: aterai
pubdate: 2004-11-22T00:57:31+09:00
description: JScrollPane上でのマウスドラッグに応じてラベルをオートスクロールします。
image: https://lh4.googleusercontent.com/_9Z4BYR88imo/TQTH2GCzRoI/AAAAAAAAAR0/FR7seILhmaM/s800/AutoScroll.png
hreflang:
    href: https://java-swing-tips.blogspot.com/2008/06/mouse-drag-auto-scrolling.html
    lang: en
comments: true
---
## 概要
`JScrollPane`上でのマウスドラッグに応じてラベルをオートスクロールします。

{% download https://lh4.googleusercontent.com/_9Z4BYR88imo/TQTH2GCzRoI/AAAAAAAAAR0/FR7seILhmaM/s800/AutoScroll.png %}

## サンプルコード
<pre class="prettyprint"><code>class ViewportDragScrollListener extends MouseAdapter
                                 implements HierarchyListener {
  private static final int SPEED = 4;
  private static final int DELAY = 10;
  private final Cursor dc;
  private final Cursor hc = Cursor.getPredefinedCursor(Cursor.HAND_CURSOR);
  private final Timer scroller;
  private final JComponent label;
  private Point startPt = new Point();
  private Point move    = new Point();

  public ViewportDragScrollListener(JComponent comp) {
    this.label = comp;
    this.dc = comp.getCursor();
    this.scroller = new Timer(DELAY, new ActionListener() {
      @Override public void actionPerformed(ActionEvent e) {
        Container c = SwingUtilities.getAncestorOfClass(JViewport.class, label);
        if (c instanceof JViewport.class) {
          JViewport vport = (JViewport) c;
          Point vp = vport.getViewPosition();
          vp.translate(move.x, move.y);
          label.scrollRectToVisible(new Rectangle(vp, vport.getSize()));
        }
      }
    });
  }
  @Override public void hierarchyChanged(HierarchyEvent e) {
    JComponent c = (JComponent) e.getSource();
    if ((e.getChangeFlags() &amp; HierarchyEvent.DISPLAYABILITY_CHANGED) != 0
        &amp;&amp; !c.isDisplayable()) {
      scroller.stop();
    }
  }
  @Override public void mouseDragged(MouseEvent e) {
    JViewport vport = (JViewport) e.getSource();
    Point pt = e.getPoint();
    int dx = startPt.x - pt.x;
    int dy = startPt.y - pt.y;
    Point vp = vport.getViewPosition();
    vp.translate(dx, dy);
    label.scrollRectToVisible(new Rectangle(vp, vport.getSize()));
    move.setLocation(SPEED * dx, SPEED * dy);
    startPt.setLocation(pt);
  }
  @Override public void mousePressed(MouseEvent e) {
    e.getComponent().setCursor(hc); //label.setCursor(hc);
    startPt.setLocation(e.getPoint());
    move.setLocation(0, 0);
    scroller.stop();
  }
  @Override public void mouseReleased(MouseEvent e) {
    e.getComponent().setCursor(dc); //label.setCursor(dc);
    scroller.start();
  }
  @Override public void mouseExited(MouseEvent e) {
    e.getComponent().setCursor(dc); //label.setCursor(dc);
    move.setLocation(0, 0);
    scroller.stop();
  }
}
</code></pre>

## 解説
上記のサンプルでは、`JViewport`内の画像ラベルをマウスでドラッグすると、その移動方向に応じて自動的にスクロールします。自動スクロール中に画像をマウスでクリックすると移動を停止します。

`javax.swing.Timer`を使うことでスクロールの開始、継続、停止を行っています。

## 参考リンク
- [JScrollPaneのViewportをマウスで掴んでスクロール](https://ateraimemo.com/Swing/HandScroll.html)
- [JTextPaneで最終行に移動](https://ateraimemo.com/Swing/CaretPosition.html)
    - `JTextPane`で文字列を挿入したときに最後まで自動スクロールするサンプル
- [2000ピクセル以上のフリー写真素材集](http://sozai-free.com/)

<!-- dummy comment line for breaking list -->

## コメント
- 猫の手スクロール風の動作に変更しました。 -- *aterai* 2007-05-24 (木) 19:16:16
- ドラッグ中は、[JScrollPaneのViewportをマウスで掴んでスクロール](https://ateraimemo.com/Swing/HandScroll.html)と同じ動作にるよう変更しました。 -- *aterai* 2011-12-22 (木) 18:38:02

<!-- dummy comment line for breaking list -->
