---
layout: post
category: swing
folder: RearrangeOrderOfPanels
title: JPanelの並び順をドラッグ＆ドロップで入れ替える
tags: [JPanel, DragAndDrop, MouseListener, MouseMotionListener, JWindow]
author: aterai
pubdate: 2014-12-08T00:00:10+09:00
description: JPanelに配置した子コンポーネントの並び順を、マウスのドラッグ＆ドロップによる入れ替えで変更します。
image: https://lh3.googleusercontent.com/-9IOKBRfVxZE/VIRiCikcIkI/AAAAAAAANss/0DrZLpxPEWo/s800/RearrangeOrderOfPanels.png
comments: true
---
## 概要
`JPanel`に配置した子コンポーネントの並び順を、マウスのドラッグ＆ドロップによる入れ替えで変更します。

{% download https://lh3.googleusercontent.com/-9IOKBRfVxZE/VIRiCikcIkI/AAAAAAAANss/0DrZLpxPEWo/s800/RearrangeOrderOfPanels.png %}

## サンプルコード
<pre class="prettyprint"><code>class RearrangingHandler extends MouseAdapter {
  private static final Rectangle R1 = new Rectangle();
  private static final Rectangle R2 = new Rectangle();
  private final Rectangle prevRect = new Rectangle();
  private final int gestureMotionThreshold = DragSource.getDragThreshold();
  private final JWindow window = new JWindow();
  private final Point startPt = new Point();
  private int index = -1;
  private Component draggingComponent;
  private Component gap;
  private final Point dragOffset = new Point();

  public RearrangingHandler() {
    super();
    window.setBackground(new Color(0x0, true));
  }
  @Override public void mousePressed(MouseEvent e) {
    if (((JComponent) e.getComponent()).getComponentCount() &lt;= 1) {
      startPt.setLocation(0, 0);
    } else {
      startPt.setLocation(e.getPoint());
    }
  }
  private void startDragging(JComponent parent, Point pt) {
    Component c = parent.getComponentAt(pt);
    index = parent.getComponentZOrder(c);
    if (Objects.equals(c, parent) || index &lt; 0) {
      return;
    }
    draggingComponent = c;
    Dimension d = draggingComponent.getSize();

    Point dp = draggingComponent.getLocation();
    dragOffset.setLocation(pt.x - dp.x, pt.y - dp.y);

    gap = Box.createRigidArea(d);
    swapComponentLocation(parent, c, gap, index);

    window.add(draggingComponent);
    //window.setSize(d);
    window.pack();

    updateWindowLocation(pt, parent);
    window.setVisible(true);
  }
  private void updateWindowLocation(Point pt, JComponent parent) {
    if (window.isVisible() &amp;&amp; Objects.nonNull(draggingComponent)) {
      Point p = new Point(pt.x - dragOffset.x, pt.y - dragOffset.y);
      SwingUtilities.convertPointToScreen(p, parent);
      window.setLocation(p);
    }
  }
  private int getTargetIndex(Rectangle r, Point pt, int i) {
    int ht2 = (int) (.5 + r.height * .5);
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
  private static void swapComponentLocation(
      Container parent, Component remove, Component add, int idx) {
    parent.remove(remove);
    parent.add(add, idx);
    parent.revalidate();
    parent.repaint();
  }
  @Override public void mouseDragged(MouseEvent e) {
    Point pt = e.getPoint();
    JComponent parent = (JComponent) e.getComponent();
    if (Objects.isNull(draggingComponent)) {
      if (startPt.distance(pt) &gt; gestureMotionThreshold) {
        startDragging(parent, pt);
      }
      return;
    }
    updateWindowLocation(pt, parent);

    if (prevRect.contains(pt)) {
      return;
    }
    for (int i = 0; i &lt; parent.getComponentCount(); i++) {
      Component c = parent.getComponent(i);
      Rectangle r = c.getBounds();
      if (Objects.equals(c, gap) &amp;&amp; r.contains(pt)) {
        return;
      }
      int tgt = getTargetIndex(r, pt, i);
      if (tgt &gt;= 0) {
        swapComponentLocation(parent, gap, gap, tgt);
        return;
      }
    }
    //System.out.println("outer");
    parent.remove(gap);
    parent.revalidate();
  }

  @Override public void mouseReleased(MouseEvent e) {
    startPt.setLocation(0, 0);
    dragOffset.setLocation(0, 0);
    prevRect.setBounds(0, 0, 0, 0);
    window.setVisible(false);

    Point pt = e.getPoint();
    JComponent parent = (JComponent) e.getComponent();
    Component cmp = draggingComponent;
    draggingComponent = null;

    for (int i = 0; i &lt; parent.getComponentCount(); i++) {
      Component c = parent.getComponent(i);
      if (Objects.equals(c, gap)) {
        swapComponentLocation(parent, gap, cmp, i);
        return;
      }
      int tgt = getTargetIndex(c.getBounds(), pt, i);
      if (tgt &gt;= 0) {
        swapComponentLocation(parent, gap, cmp, tgt);
        return;
      }
    }
    if (parent.getParent().getBounds().contains(pt)) {
      swapComponentLocation(parent, gap, cmp, parent.getComponentCount());
    } else {
      swapComponentLocation(parent, gap, cmp, index);
    }
  }
}
</code></pre>

## 解説
上記のサンプルでは、親の`JPanel`に`MouseListener`と`MouseMotionListener`を継承するハンドラを追加し、子の`JPanel`をマウスドラッグで任意の位置に差し替えることが出来ます。移動中の子`JPanel`は、ドラッグ・イメージとして別`JWindow`でカーソル位置に表示されます。

- 使用しているハンドラは、以下の`2`点を除いて[JToolBarに配置したアイコンをドラッグして並べ替える](https://ateraimemo.com/Swing/RearrangeToolBarIcon.html)で使用しているものとほぼ同一
    - 水平ではなく垂直方向に入れ替えを行うように変更
    - サイズ(高さ)の異なるパネルの入れ替えに対応

<!-- dummy comment line for breaking list -->

## 参考リンク
- [JToolBarに配置したアイコンをドラッグして並べ替える](https://ateraimemo.com/Swing/RearrangeToolBarIcon.html)
- [swing - Java, drag and drop to change the order of panels - Stack Overflow](https://stackoverflow.com/questions/27245283/java-drag-and-drop-to-change-the-order-of-panels)
- [JLayerを使用してコンポーネントの並べ替えを行う](https://ateraimemo.com/Swing/ReorderingLayer.html)
    - `JTable`の列入れ替え風に親パネルの範囲内のみ子コンポーネントをドラッグ可能にして入れ替えるサンプル

<!-- dummy comment line for breaking list -->

## コメント
