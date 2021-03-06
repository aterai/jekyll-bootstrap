---
layout: post
category: swing
folder: ReorderingLayer
title: JLayerを使用してコンポーネントの並べ替えを行う
tags: [JLayer, DragAndDrop, BoxLayout]
author: aterai
pubdate: 2015-04-06T00:00:32+09:00
description: JPanel内に配置したコンポーネントの並べ替えで、ドラッグ中のコンポーネントをJLayerで描画します。
image: https://lh3.googleusercontent.com/-gW9pryNmoYY/VSFFArmXElI/AAAAAAAAN2A/CYZqhoCR0EE/s800/ReorderingLayer.png
comments: true
---
## 概要
`JPanel`内に配置したコンポーネントの並べ替えで、ドラッグ中のコンポーネントを`JLayer`で描画します。

{% download https://lh3.googleusercontent.com/-gW9pryNmoYY/VSFFArmXElI/AAAAAAAAN2A/CYZqhoCR0EE/s800/ReorderingLayer.png %}

## サンプルコード
<pre class="prettyprint"><code>class ReorderingLayerUI&lt;V extends JComponent&gt; extends LayerUI&lt;V&gt; {
  private static final Rectangle TOP_HALF_RECT = new Rectangle();
  private static final Rectangle BOTTOM_HALF_RECT = new Rectangle();
  private static final Rectangle INNER_RECT = new Rectangle();
  private static final Rectangle PREV_RECT = new Rectangle();
  private static final Rectangle DRAGGING_RECT = new Rectangle();
  private final Point startPt = new Point();
  private final Point dragOffset = new Point();
  private final Container canvas = new JPanel();
  private final int gestureMotionThreshold = DragSource.getDragThreshold();

  private Component draggingComponent;
  private Component fillerComponent;

  @Override public void paint(Graphics g, JComponent c) {
    super.paint(g, c);
    if (c instanceof JLayer &amp;&amp; Objects.nonNull(draggingComponent)) {
      SwingUtilities.paintComponent(g, draggingComponent, canvas, DRAGGING_RECT);
    }
  }

  @Override public void installUI(JComponent c) {
    super.installUI(c);
    if (c instanceof JLayer) {
      ((JLayer&lt;?&gt;) c).setLayerEventMask(AWTEvent.MOUSE_EVENT_MASK | AWTEvent.MOUSE_MOTION_EVENT_MASK);
    }
  }

  @Override public void uninstallUI(JComponent c) {
    if (c instanceof JLayer) {
      ((JLayer&lt;?&gt;) c).setLayerEventMask(0);
    }
    super.uninstallUI(c);
  }

  @Override protected void processMouseEvent(MouseEvent e, JLayer&lt;? extends V&gt; l) {
    JComponent parent = l.getView();
    switch (e.getID()) {
      case MouseEvent.MOUSE_PRESSED:
        if (parent.getComponentCount() &gt; 0) {
          startPt.setLocation(e.getPoint());
          l.repaint();
        }
        break;
      case MouseEvent.MOUSE_RELEASED:
        if (Objects.nonNull(draggingComponent)) {
          // swap the dragging panel and the dummy filler
          int idx = parent.getComponentZOrder(fillerComponent);
          replaceComponents(parent, fillerComponent, draggingComponent, idx);
          draggingComponent = null;
        }
        break;
      default:
        break;
    }
  }

  @Override protected void processMouseMotionEvent(MouseEvent e, JLayer&lt;? extends V&gt; l) {
    if (e.getID() == MouseEvent.MOUSE_DRAGGED) {
      mouseDragged(l.getView(), e.getPoint());
      l.repaint();
    }
  }

  private void mouseDragged(JComponent parent, Point pt) {
    if (Objects.isNull(draggingComponent)) {
      // MotionThreshold
      if (startPt.distance(pt) &gt; gestureMotionThreshold) {
        startDragging(parent, pt);
      }
      return;
    }

    // update the filler panel location
    if (!PREV_RECT.contains(pt)) {
      updateFillerLocation(parent, fillerComponent, pt);
    }

    // update the dragging panel location
    updateDraggingPanelLocation(parent, pt, dragOffset);
  }

  private void startDragging(JComponent parent, Point pt) {
    Component c = parent.getComponentAt(pt);
    int index = parent.getComponentZOrder(c);
    if (Objects.equals(c, parent) || index &lt; 0) {
      return;
    }
    draggingComponent = c;

    Rectangle r = draggingComponent.getBounds();
    DRAGGING_RECT.setBounds(r); // save draggingComponent size
    dragOffset.setLocation(pt.x - r.x, pt.y - r.y);

    fillerComponent = Box.createRigidArea(r.getSize());
    replaceComponents(parent, c, fillerComponent, index);

    updateDraggingPanelLocation(parent, pt, dragOffset);
  }

  private static void updateDraggingPanelLocation(JComponent parent, Point pt, Point dragOffset) {
    Insets i = parent.getInsets();
    Rectangle r = SwingUtilities.calculateInnerArea(parent, INNER_RECT);
    int x = r.x;
    int y = pt.y - dragOffset.y;
    int h = DRAGGING_RECT.height;
    int yy;
    if (y &lt; i.top) {
      yy = i.top;
    } else {
      yy = r.contains(x, y + h) ? y : r.height + i.top - h;
    }
    DRAGGING_RECT.setLocation(x, yy);
  }

  private static void updateFillerLocation(Container parent, Component filler, Point pt) {
    // change the dummy filler location
    for (int i = 0; i &lt; parent.getComponentCount(); i++) {
      Component c = parent.getComponent(i);
      Rectangle r = c.getBounds();
      if (Objects.equals(c, filler) &amp;&amp; r.contains(pt)) {
        return;
      }
      int tgt = getTargetIndex(r, pt, i);
      if (tgt &gt;= 0) {
        replaceComponents(parent, filler, filler, tgt);
        return;
      }
    }
  }

  private static int getTargetIndex(Rectangle r, Point pt, int i) {
    int ht2 = (int) (.5 + r.height * .5);
    TOP_HALF_RECT.setBounds(r.x, r.y, r.width, ht2);
    BOTTOM_HALF_RECT.setBounds(r.x, r.y + ht2, r.width, ht2);
    if (TOP_HALF_RECT.contains(pt)) {
      PREV_RECT.setBounds(TOP_HALF_RECT);
      return i &gt; 1 ? i : 0;
    } else if (BOTTOM_HALF_RECT.contains(pt)) {
      PREV_RECT.setBounds(BOTTOM_HALF_RECT);
      return i;
    }
    return -1;
  }

  private static void replaceComponents(Container parent, Component remove, Component insert, int idx) {
    parent.remove(remove);
    parent.add(insert, idx);
    parent.revalidate();
    parent.repaint();
  }
}
</code></pre>

## 解説
並べ替えの処理などは、[JPanelの並び順をドラッグ＆ドロップで入れ替える](https://ateraimemo.com/Swing/RearrangeOrderOfPanels.html)とほぼ同じものを使用していますが、こちらはドラッグ中のコンポーネントの移動可能領域を親の`JPanel`内のみに制限しているので`JWindow`ではなく`JLayer`を使用しています。

- ドラッグ中のコンポーネントの位置・サイズ
    - 位置: 親の`JPanel`から内部余白を除いた部分をドラッグ可能な領域(`SwingUtilities.calculateInnerArea(...)`で取得)に設定し、その範囲内に位置を制限
    - サイズ: `LayerUI#paint(...)`内でのドラッグ中のコンポーネントの描画には、`SwingUtilities.paintComponent(...)`を使用しているが、この時ドラッグ中のコンポーネントは親の`JPanel`の子ではなくなっているため、`getSize()`で大きさを取得できない
        - そのため、ドラッグ開始前にそのサイズを別途記憶しておく必要がある

<!-- dummy comment line for breaking list -->

## 参考リンク
- [JPanelの並び順をドラッグ＆ドロップで入れ替える](https://ateraimemo.com/Swing/RearrangeOrderOfPanels.html)

<!-- dummy comment line for breaking list -->

## コメント
- `src.zip`などがダウンロードできない不具合を修正。 -- *aterai* 2015-04-20 (月) 17:57:58

<!-- dummy comment line for breaking list -->
