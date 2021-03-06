---
layout: post
category: swing
folder: TreeDragScroll
title: JTreeの余白をドラッグしてスクロール
tags: [MouseListener, MouseMotionListener, JViewport, JScrollPane, JTree, JComponent]
author: aterai
pubdate: 2011-12-26T14:16:38+09:00
description: JTreeの余白などをマウスでドラッグしてスクロールします。
image: https://lh3.googleusercontent.com/-8b-0M5bS9Tw/Tvf_XhVVreI/AAAAAAAABHU/BdECxkBAdzU/s800/TreeDragScroll.png
comments: true
---
## 概要
`JTree`の余白などをマウスでドラッグしてスクロールします。

{% download https://lh3.googleusercontent.com/-8b-0M5bS9Tw/Tvf_XhVVreI/AAAAAAAABHU/BdECxkBAdzU/s800/TreeDragScroll.png %}

## サンプルコード
<pre class="prettyprint"><code>class DragScrollListener extends MouseAdapter {
  private Cursor defCursor = Cursor.getDefaultCursor();
  private Cursor hndCursor = Cursor.getPredefinedCursor(Cursor.HAND_CURSOR);
  private Point pp = new Point();
  @Override public void mouseDragged(MouseEvent e) {
    Component c = e.getComponent();
    Container p = SwingUtilities.getUnwrappedParent(c);
    if (p instanceof JViewport) {
      JViewport vport = (JViewport) p;
      Point cp = SwingUtilities.convertPoint(c, e.getPoint(), vport);
      Point vp = vport.getViewPosition();
      vp.translate(pp.x - cp.x, pp.y - cp.y);
      ((JComponent) c).scrollRectToVisible(new Rectangle(vp, vport.getSize()));
      pp.setLocation(cp);
    }
  }
  @Override public void mousePressed(MouseEvent e) {
    Component c = e.getComponent();
    Container p = SwingUtilities.getUnwrappedParent(c);
    if (p instanceof JViewport) {
      c.setCursor(hndCursor);
      JViewport vport = (JViewport) p;
      Point cp = SwingUtilities.convertPoint(c, e.getPoint(), vport);
      pp.setLocation(cp);
    }
  }
  @Override public void mouseReleased(MouseEvent e) {
    e.getComponent().setCursor(defCursor);
  }
}
</code></pre>

## 解説
上記のサンプルでは、`JTree`に`MouseListener`, `MouseMotionListener`を設定し、マウスドラッグを`JViewport`の座標に変換して、`scrollRectToVisible(...)`メソッドを使ったスクロールをおこなっています。

<pre class="prettyprint"><code>MouseAdapter ma = new DragScrollListener();
tree2.addMouseMotionListener(ma);
tree2.addMouseListener(ma);
</code></pre>

- - - -
[JScrollPaneのViewportをマウスで掴んでスクロール](https://ateraimemo.com/Swing/HandScroll.html)と、ほとんど同じことをしていますが、`JLabel`とは異なり、`JTree`にはデフォルトで`MouseListener`, `MouseMotionListener`が設定されているため、`JViewport`にリスナーを設定しても`JTree`までマウスイベントが伝わりません。例えば、以下のように`JComponent#dispatchEvent(...)`で、`JTree`の親の`JViewport`にイベントを転送する必要があります。

<pre class="prettyprint"><code>MouseAdapter ma = new HandScrollListener();
JScrollPane scroll = new JScrollPane(tree1);
JViewport vport = scroll.getViewport();
vport.addMouseMotionListener(ma);
vport.addMouseListener(ma);
MouseAdapter dummy = new MouseAdapter() {
  private void dispatchEvent(MouseEvent e) {
    JComponent c = (JComponent) e.getComponent();
    JComponent p = (JComponent) e.getComponent().getParent();
    p.dispatchEvent(SwingUtilities.convertMouseEvent(c, e, p));
  }
  @Override public void mouseDragged(MouseEvent e)  { dispatchEvent(e); }
  @Override public void mouseClicked(MouseEvent e)  { dispatchEvent(e); }
  @Override public void mouseEntered(MouseEvent e)  { dispatchEvent(e); }
  @Override public void mouseExited(MouseEvent e)   { dispatchEvent(e); }
  @Override public void mousePressed(MouseEvent e)  { dispatchEvent(e); }
  @Override public void mouseReleased(MouseEvent e) { dispatchEvent(e); }
};
</code></pre>

## 参考リンク
- [JScrollPaneのViewportをマウスで掴んでスクロール](https://ateraimemo.com/Swing/HandScroll.html)
- [JScrollPane内にある複数Componentを配置したJPanelをJLayerを使ってドラッグスクロール](https://ateraimemo.com/Swing/DragScrollLayer.html)
    - `JDK 1.7.0`以上の場合、`JComponent#dispatchEvent(...)`を伝搬させるリスナーを追加なくても、`JLayer`を使用すればすべての子コンポーネントで`MouseEvent`が取得できる

<!-- dummy comment line for breaking list -->

## コメント
