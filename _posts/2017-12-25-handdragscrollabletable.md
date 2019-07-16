---
layout: post
category: swing
folder: HandDragScrollableTable
title: JTableをスクロールバー無しのドラッグでスクロールする
tags: [JTable, JScrollPane, MouseMotionListener, Timer]
author: aterai
pubdate: 2017-12-25T14:36:51+09:00
description: JTableをスクロールバーではなく、内部の行をマウスでドラッグすることでスクロール可能になるよう設定します。
image: https://drive.google.com/uc?id=10Tv7RlmeMiqhXBuq5fgixQ3v4KR8p5_9
comments: true
---
## 概要
`JTable`をスクロールバーではなく、内部の行をマウスでドラッグすることでスクロール可能になるよう設定します。

{% download https://drive.google.com/uc?id=10Tv7RlmeMiqhXBuq5fgixQ3v4KR8p5_9 %}

## サンプルコード
<pre class="prettyprint"><code>class DragScrollingListener extends MouseAdapter {
  protected static final int VELOCITY = 5;
  protected static final int DELAY = 10;
  protected static final double GRAVITY = .95;
  protected final Cursor dc = Cursor.getPredefinedCursor(Cursor.DEFAULT_CURSOR);
  protected final Cursor hc = Cursor.getPredefinedCursor(Cursor.HAND_CURSOR);
  protected final Timer scroller;
  protected final Point startPt = new Point();
  protected final Point delta = new Point();

  protected DragScrollingListener(JComponent c) {
    super();
    this.scroller = new Timer(DELAY, e -&gt; {
      JViewport vport = (JViewport) SwingUtilities.getUnwrappedParent(c);
      Point vp = vport.getViewPosition();
      vp.translate(-delta.x, -delta.y);
      c.scrollRectToVisible(new Rectangle(vp, vport.getSize()));
      if (Math.abs(delta.x) &gt; 0 || Math.abs(delta.y) &gt; 0) {
        delta.setLocation((int) (delta.x * GRAVITY), (int) (delta.y * GRAVITY));
      } else {
        ((Timer) e.getSource()).stop();
      }
    });
  }
  @Override public void mousePressed(MouseEvent e) {
    Component c = e.getComponent();
    c.setCursor(hc);
    c.setEnabled(false);
    Container p = SwingUtilities.getUnwrappedParent(c);
    if (p instanceof JViewport) {
      JViewport vport = (JViewport) p;
      Point cp = SwingUtilities.convertPoint(c, e.getPoint(), vport);
      startPt.setLocation(cp);
      scroller.stop();
    }
  }
  @Override public void mouseDragged(MouseEvent e) {
    Component c = e.getComponent();
    Container p = SwingUtilities.getUnwrappedParent(c);
    if (p instanceof JViewport) {
      JViewport vport = (JViewport) p;
      Point cp = SwingUtilities.convertPoint(c, e.getPoint(), vport);
      Point vp = vport.getViewPosition();
      vp.translate(startPt.x - cp.x, startPt.y - cp.y);
      delta.setLocation(VELOCITY * (cp.x - startPt.x), VELOCITY * (cp.y - startPt.y));
      ((JComponent) c).scrollRectToVisible(new Rectangle(vp, vport.getSize()));
      startPt.setLocation(cp);
    }
  }
  @Override public void mouseReleased(MouseEvent e) {
    Component c = e.getComponent();
    c.setCursor(dc);
    c.setEnabled(true);
    scroller.start();
  }
}
</code></pre>

## 解説
- [JTreeの余白をドラッグしてスクロール](https://ateraimemo.com/Swing/TreeDragScroll.html)の`MouseMotionListener`に[JScrollPaneでキネティックスクロール](https://ateraimemo.com/Swing/KineticScrolling.html)の`Timer`を使った慣性処理を適用して、行のドラッグスクロールを実行
- `JScrollBar`を常に非表示にしているので、マウスホイールによるスクロールは不可
    - [JScrollBarが非表示でもMouseWheelでScrollする](https://ateraimemo.com/Swing/MouseWheelScroll.html)で回避可能
- 行選択と干渉する場合があるので、ドラッグ中は`JTable#setEnabled(false)`で行選択などを無効化
    - 複数行の選択が不可になる

<!-- dummy comment line for breaking list -->

## 参考リンク
- [JTreeの余白をドラッグしてスクロール](https://ateraimemo.com/Swing/TreeDragScroll.html)
- [JScrollPaneでキネティックスクロール](https://ateraimemo.com/Swing/KineticScrolling.html)
- [JScrollBarが非表示でもMouseWheelでScrollする](https://ateraimemo.com/Swing/MouseWheelScroll.html)
- [JTableのドラッグスクロールをタッチスクリーンで実行する](https://ateraimemo.com/Swing/TableScrollOnTouchScreen.html)

<!-- dummy comment line for breaking list -->

## コメント
