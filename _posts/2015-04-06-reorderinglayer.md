---
layout: post
category: swing
folder: ReorderingLayer
title: JLayerを使用してコンポーネントの並べ替えを行う
tags: [JLayer, DragAndDrop, BoxLayout]
author: aterai
pubdate: 2015-04-06T00:00:32+09:00
description: JPanel内に配置したコンポーネントの並べ替えで、ドラッグ中のコンポーネントをJLayerで描画します。
comments: true
---
## 概要
`JPanel`内に配置したコンポーネントの並べ替えで、ドラッグ中のコンポーネントを`JLayer`で描画します。

{% download https://lh3.googleusercontent.com/-gW9pryNmoYY/VSFFArmXElI/AAAAAAAAN2A/CYZqhoCR0EE/s800/ReorderingLayer.png %}

## サンプルコード
<pre class="prettyprint"><code>class ReorderingLayerUI extends LayerUI&lt;JComponent&gt; {
  private static final Rectangle R1 = new Rectangle();
  private static final Rectangle R2 = new Rectangle();
  private static final Rectangle R3 = new Rectangle();
  private final Rectangle prevRect = new Rectangle();
  private final Rectangle draggingRect = new Rectangle();
  private final Point startPt = new Point(-100, -100);
  private final Point dragOffset = new Point();
  private final JComponent rubberStamp = new JPanel();
  private final int gestureMotionThreshold = DragSource.getDragThreshold();

  private Component draggingComonent;
  private Component gap;
  private int index = -1;

  @Override public void paint(Graphics g, JComponent c) {
    super.paint(g, c);
    if (c instanceof JLayer &amp;&amp; Objects.nonNull(draggingComonent)) {
      SwingUtilities.paintComponent(g, draggingComonent, rubberStamp, draggingRect);
    }
  }

  @Override public void installUI(JComponent c) {
    super.installUI(c);
    if (c instanceof JLayer) {
      ((JLayer) c).setLayerEventMask(
          AWTEvent.MOUSE_EVENT_MASK | AWTEvent.MOUSE_MOTION_EVENT_MASK);
    }
  }

  @Override public void uninstallUI(JComponent c) {
    if (c instanceof JLayer) {
      ((JLayer) c).setLayerEventMask(0);
    }
    super.uninstallUI(c);
  }

  @Override protected void processMouseEvent(
      MouseEvent e, JLayer&lt;? extends JComponent&gt; l) {
    JComponent parent = l.getView();
    switch (e.getID()) {
    case MouseEvent.MOUSE_PRESSED:
      if (parent.getComponentCount() &lt;= 1) {
        return;
      }
      startPt.setLocation(e.getPoint());
      l.repaint();
      break;
    case MouseEvent.MOUSE_RELEASED:
      if (Objects.isNull(draggingComonent)) {
        return;
      }
      Point pt = e.getPoint();

      Component cmp = draggingComonent;
      draggingComonent = null;

      //swap the dragging panel and the dummy filler
      for (int i = 0; i &lt; parent.getComponentCount(); i++) {
        Component c = parent.getComponent(i);
        if (Objects.equals(c, gap)) {
          replaceComponent(parent, gap, cmp, i);
          return;
        }
        int tgt = getTargetIndex(c.getBounds(), pt, i);
        if (tgt &gt;= 0) {
          replaceComponent(parent, gap, cmp, tgt);
          return;
        }
      }
      if (parent.getParent().getBounds().contains(pt)) {
        replaceComponent(parent, gap, cmp, parent.getComponentCount());
      } else {
        replaceComponent(parent, gap, cmp, index);
      }
      l.repaint();
      break;
    default:
      break;
    }
  }

  @Override protected void processMouseMotionEvent(
      MouseEvent e, JLayer&lt;? extends JComponent&gt; l) {
    if (e.getID() == MouseEvent.MOUSE_DRAGGED) {
      Point pt = e.getPoint();
      JComponent parent = l.getView();

      if (Objects.isNull(draggingComonent)) {
        //MotionThreshold
        double a = Math.pow(pt.x - startPt.x, 2);
        double b = Math.pow(pt.y - startPt.y, 2);
        if (Math.sqrt(a + b) &gt; gestureMotionThreshold) {
          startDragging(parent, pt);
        }
        return;
      }

      //update the cursor window location
      updateWindowLocation(pt, parent);
      l.repaint();

      if (prevRect.contains(pt)) {
        return;
      }

      //change the dummy filler location
      for (int i = 0; i &lt; parent.getComponentCount(); i++) {
        Component c = parent.getComponent(i);
        Rectangle r = c.getBounds();
        if (Objects.equals(c, gap) &amp;&amp; r.contains(pt)) {
          return;
        }
        int tgt = getTargetIndex(r, pt, i);
        if (tgt &gt;= 0) {
          replaceComponent(parent, gap, gap, tgt);
          return;
        }
      }
      parent.revalidate();
      l.repaint();
    }
  }

  private void startDragging(JComponent parent, Point pt) {
    Component c = parent.getComponentAt(pt);
    index = parent.getComponentZOrder(c);
    if (Objects.equals(c, parent) || index &lt; 0) {
      return;
    }
    draggingComonent = c;

    Rectangle r = draggingComonent.getBounds();
    draggingRect.setBounds(r); //save draggingComonent size
    dragOffset.setLocation(pt.x - r.x, pt.y - r.y);

    gap = Box.createRigidArea(r.getSize());
    replaceComponent(parent, c, gap, index);

    updateWindowLocation(pt, parent);
  }

  private void updateWindowLocation(Point pt, JComponent parent) {
    Insets i = parent.getInsets();
    Rectangle r = SwingUtilities.calculateInnerArea(parent, R3);
    int x = r.x;
    int y = pt.y - dragOffset.y;
    int h = draggingRect.height;
    int yy = y &lt; i.top ? i.top : r.contains(x, y + h) ? y : r.height + i.top - h;
    draggingRect.setLocation(x, yy);
  }

  private int getTargetIndex(Rectangle r, Point pt, int i) {
    int ht2 = (int)(.5 + r.height * .5);
    R1.setBounds(r.x, r.y,       r.width, ht2);
    R2.setBounds(r.x, r.y + ht2, r.width, ht2);
    if (R1.contains(pt)) {
      prevRect.setBounds(R1);
      return i - 1 &gt; 0 ? i : 0;
    } else if (R2.contains(pt)) {
      prevRect.setBounds(R2);
      return i;
    }
    return -1;
  }

  private static void replaceComponent(
      Container parent, Component remove, Component insert, int idx) {
    parent.remove(remove);
    parent.add(insert, idx);
    parent.revalidate();
    parent.repaint();
  }
}
</code></pre>

## 解説
並べ替えの処理などは、[JPanelの並び順をドラッグ＆ドロップで入れ替える](http://ateraimemo.com/Swing/RearrangeOrderOfPanels.html)と同じものを使用していますが、こちらはドラッグ中のコンポーネントの描画を親のJPanel内でのみに制限しているので、`JWindow`ではなく`JLayer`を使用しています。

- ドラッグ中のコンポーネントの位置・サイズ
    - 位置: 親の`JPanel`から内部余白を除いた部分をドラッグ可能な領域(`SwingUtilities.calculateInnerArea(...)`で取得)に設定し、その範囲内に位置を制限
    - サイズ: `LayerUI#paint(...)`内でのドラッグ中のコンポーネントの描画には、`SwingUtilities.paintComponent(...)`を使用しているが、この時ドラッグ中のコンポーネントは親の`JPanel`の子ではなくなっているため、`getSize()`で大きさを取得できない
        - そのため、ドラッグ開始前にそのサイズを別途記憶しておく必要がある

<!-- dummy comment line for breaking list -->

## 参考リンク
- [JPanelの並び順をドラッグ＆ドロップで入れ替える](http://ateraimemo.com/Swing/RearrangeOrderOfPanels.html)

<!-- dummy comment line for breaking list -->

## コメント