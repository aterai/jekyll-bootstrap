---
layout: post
category: swing
folder: RearrangeToolBarIcon
title: JToolBarに配置したアイコンをドラッグして並べ替える
tags: [JToolBar, JLabel, Icon, DragAndDrop, MouseListener, MouseMotionListener, JWindow]
author: aterai
pubdate: 2013-04-08T01:18:50+09:00
description: JToolBarに配置したアイコンをドラッグ＆ドロップで並べ替えます。
image: https://lh6.googleusercontent.com/-bxLoJ6g9K_I/UWBOghG3kxI/AAAAAAAABpQ/tvVELkL1RV0/s800/RearrangeToolBarIcon.png
hreflang:
    href: https://java-swing-tips.blogspot.com/2013/04/rearrange-jtoolbar-icon-by-drag-and-drop.html
    lang: en
comments: true
---
## 概要
`JToolBar`に配置したアイコンをドラッグ＆ドロップで並べ替えます。

{% download https://lh6.googleusercontent.com/-bxLoJ6g9K_I/UWBOghG3kxI/AAAAAAAABpQ/tvVELkL1RV0/s800/RearrangeToolBarIcon.png %}

## サンプルコード
<pre class="prettyprint"><code>class DragHandler extends MouseAdapter {
  private final JWindow window = new JWindow();
  private Component draggingComponent = null;
  private int index = -1;
  private Component gap = Box.createHorizontalStrut(24);
  private Point startPt = null;
  private int gestureMotionThreshold = DragSource.getDragThreshold();
  public DragHandler() {
    window.setBackground(new Color(0x0, true));
  }
  @Override public void mousePressed(MouseEvent e) {
    JComponent parent = (JComponent) e.getComponent();
    if (parent.getComponentCount() &lt;= 1) {
      startPt = null;
      return;
    }
    startPt = e.getPoint();
  }
  @Override public void mouseDragged(MouseEvent e) {
    Point pt = e.getPoint();
    JComponent parent = (JComponent) e.getComponent();
    if (startPt != null &amp;&amp; startPt.distance(pt) &gt; gestureMotionThreshold) {
      startPt = null;
      Component c = parent.getComponentAt(pt);
      index = parent.getComponentZOrder(c);
      if (c == parent || index &lt; 0) {
        return;
      }
      draggingComponent = c;

      parent.remove(draggingComponent);
      parent.add(gap, index);
      parent.revalidate();
      parent.repaint();

      window.add(draggingComponent);
      window.pack();

      Dimension d = draggingComponent.getPreferredSize();
      Point p = new Point(pt.x - d.width / 2, pt.y - d.height / 2);
      SwingUtilities.convertPointToScreen(p, parent);
      window.setLocation(p);
      window.setVisible(true);

      return;
    }
    if (!window.isVisible() || draggingComponent == null) {
      return;
    }

    Dimension d = draggingComponent.getPreferredSize();
    Point p = new Point(pt.x - d.width / 2, pt.y - d.height / 2);
    SwingUtilities.convertPointToScreen(p, parent);
    window.setLocation(p);

    for (int i = 0; i &lt; parent.getComponentCount(); i++) {
      Component c = parent.getComponent(i);
      Rectangle r = c.getBounds();
      Rectangle r1 = new Rectangle(r.x, r.y, r.width / 2, r.height);
      Rectangle r2 = new Rectangle(r.x + r.width / 2, r.y, r.width / 2, r.height);
      if (r1.contains(pt)) {
        if (c == gap) {
          return;
        }
        int n = i - 1 &gt;= 0 ? i : 0;
        parent.remove(gap);
        parent.add(gap, n);
        parent.revalidate();
        parent.repaint();
        return;
      } else if (r2.contains(pt)) {
        if (c == gap) {
          return;
        }
        parent.remove(gap);
        parent.add(gap, i);
        parent.revalidate();
        parent.repaint();
        return;
      }
    }
    parent.remove(gap);
    parent.revalidate();
    parent.repaint();
  }

  @Override public void mouseReleased(MouseEvent e) {
    startPt = null;
    if (!window.isVisible() || draggingComponent == null) {
      return;
    }
    Point pt = e.getPoint();
    JComponent parent = (JComponent) e.getComponent();

    Component cmp = draggingComponent;
    draggingComponent = null;
    window.setVisible(false);

    for (int i = 0; i &lt; parent.getComponentCount(); i++) {
      Component c = parent.getComponent(i);
      Rectangle r = c.getBounds();
      Rectangle r1 = new Rectangle(r.x, r.y, r.width / 2, r.height);
      Rectangle r2 = new Rectangle(r.x + r.width / 2, r.y, r.width / 2, r.height);
      if (r1.contains(pt)) {
        int n = i - 1 &gt;= 0 ? i : 0;
        parent.remove(gap);
        parent.add(cmp, n);
        parent.revalidate();
        parent.repaint();
        return;
      } else if (r2.contains(pt)) {
        parent.remove(gap);
        parent.add(cmp, i);
        parent.revalidate();
        parent.repaint();
        return;
      }
    }
    if (parent.getBounds().contains(pt)) {
      parent.remove(gap);
      parent.add(cmp);
    } else {
      parent.remove(gap);
      parent.add(cmp, index);
    }
    parent.revalidate();
    parent.repaint();
  }
}
</code></pre>

## 解説
上記のサンプルでは、`JToolBar`に`MouseListener`と`MouseMotionListener`を追加して、`JLabel`に配置したアイコンを並べ替えています。

- ドラッグされて移動対象になった`JLabel`(アイコン)は親`JToolBar`から削除され、透明な別`JWindow`に移動
    - `JWindow`なので、元のフレームの外側でも表示可能
- ドロップする位置に`JWindow`が移動してきた場合、`JToolBar`に`Box.createHorizontalStrut(24);`で作成したアイコンと同じ幅の`Box`を配置
- `JLabel`がドロップされるとダミーの`Box`は削除され、`JLabel`と入れ替え
    - `JWindow`は非表示に設定
    - `JToolBar`以外の場所にドロップされた場合は、ドラッグ前の位置に`JLabel`を戻す

<!-- dummy comment line for breaking list -->

- - - -
- 制限
    - `JToolBar#setFloatable(false);`にしないとアイコンを移動できない
    - `JButton`などを移動できない
    - 非表示のコンポーネント(`Box.createGlue()`など)がドラッグできてしまう
    - `Ubuntu`などで移動の描画がチラつく

<!-- dummy comment line for breaking list -->

## 参考リンク
- [JFrameの外側でもドラッグアイコンを表示する](https://ateraimemo.com/Swing/DragSourceMotionListener.html)
- [JPanelの並び順をドラッグ＆ドロップで入れ替える](https://ateraimemo.com/Swing/RearrangeOrderOfPanels.html)

<!-- dummy comment line for breaking list -->

## コメント
- メモ: `JLayer`などを使用すれば、`JButton`の移動も可能…な気がする。 -- *aterai* 2013-04-08 (月) 21:04:19

<!-- dummy comment line for breaking list -->
