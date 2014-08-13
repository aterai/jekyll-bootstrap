---
layout: post
title: JTreeの余白をドラッグしてスクロール
category: swing
folder: TreeDragScroll
tags: [MouseListener, MouseMotionListener, JViewport, JScrollPane, JTree, JComponent]
author: aterai
comments: true
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2011-12-26

## JTreeの余白をドラッグしてスクロール
`JTree`の余白などをマウスでドラッグしてスクロールします。


{% download https://lh3.googleusercontent.com/-8b-0M5bS9Tw/Tvf_XhVVreI/AAAAAAAABHU/BdECxkBAdzU/s800/TreeDragScroll.png %}

### サンプルコード
<pre class="prettyprint"><code>class DragScrollListener extends MouseAdapter {
  Cursor defCursor = Cursor.getPredefinedCursor(Cursor.DEFAULT_CURSOR);
  Cursor hndCursor = Cursor.getPredefinedCursor(Cursor.HAND_CURSOR);
  Point pp = new Point();
  @Override public void mouseDragged(MouseEvent e) {
    JComponent jc = (JComponent)e.getSource();
    Container c = jc.getParent();
    if(c instanceof JViewport) {
      JViewport vport = (JViewport)c;
      Point cp = SwingUtilities.convertPoint(jc,e.getPoint(),vport);
      Point vp = vport.getViewPosition();
      vp.translate(pp.x-cp.x, pp.y-cp.y);
      jc.scrollRectToVisible(new Rectangle(vp, vport.getSize()));
      pp.setLocation(cp);
    }
  }
  @Override public void mousePressed(MouseEvent e) {
    JComponent jc = (JComponent)e.getSource();
    Container c = jc.getParent();
    if(c instanceof JViewport) {
      jc.setCursor(hndCursor);
      JViewport vport = (JViewport)c;
      Point cp = SwingUtilities.convertPoint(jc,e.getPoint(),vport);
      pp.setLocation(cp);
    }
  }
  @Override public void mouseReleased(MouseEvent e) {
    ((JComponent)e.getSource()).setCursor(defCursor);
  }
}
</code></pre>

### 解説
上記のサンプルでは、`JTree`に`MouseListener`, `MouseMotionListener`を設定し、マウスドラッグを`JViewport`の座標に変換して、`scrollRectToVisible(...)`メソッドを使ったスクロールをおこなっています。

<pre class="prettyprint"><code>MouseAdapter ma = new DragScrollListener();
tree2.addMouseMotionListener(ma);
tree2.addMouseListener(ma);
</code></pre>

- - - -
[JScrollPaneのViewportをマウスで掴んでスクロール](http://terai.xrea.jp/Swing/HandScroll.html)と、ぼぼ同じことをしていますが、`JLabel`とは異なり、`JTree`にはデフォルトで`MouseListener`, `MouseMotionListener`が設定されているため、`JViewport`にリスナーを設定しても`JTree`までマウスイベントが伝わりません。例えば、以下のように`JComponent#dispatchEvent(...)`で、`JTree`の親の`JViewport`にイベントを投げる必要があります。

<pre class="prettyprint"><code>MouseAdapter ma = new HandScrollListener();
JScrollPane scroll = new JScrollPane(tree1);
JViewport vport = scroll.getViewport();
vport.addMouseMotionListener(ma);
vport.addMouseListener(ma);
MouseAdapter dummy = new MouseAdapter() {
  private void dispatchEvent(MouseEvent e) {
    JComponent c = (JComponent)e.getComponent();
    JComponent p = (JComponent)e.getComponent().getParent();
    p.dispatchEvent(SwingUtilities.convertMouseEvent(c,e,p));
  }
  @Override public void mouseDragged(MouseEvent e)  { dispatchEvent(e); }
  @Override public void mouseClicked(MouseEvent e)  { dispatchEvent(e); }
  @Override public void mouseEntered(MouseEvent e)  { dispatchEvent(e); }
  @Override public void mouseExited(MouseEvent e)   { dispatchEvent(e); }
  @Override public void mousePressed(MouseEvent e)  { dispatchEvent(e); }
  @Override public void mouseReleased(MouseEvent e) { dispatchEvent(e); }
};
</code></pre>

- 上記のような`JComponent#dispatchEvent(...)`を伝搬させるリスナーを追加なくても、`JDK 1.7.0`以上の場合、`JLayer`を使用して子コンポーネントのすべての`MouseEvent`キャッチする方法を使用することができます。
    - [JScrollPane内にある複数Componentを配置したJPanelをJLayerを使ってドラッグスクロール](http://terai.xrea.jp/Swing/DragScrollLayer.html)

<!-- dummy comment line for breaking list -->

### 参考リンク
- [JScrollPaneのViewportをマウスで掴んでスクロール](http://terai.xrea.jp/Swing/HandScroll.html)
- [JScrollPane内にある複数Componentを配置したJPanelをJLayerを使ってドラッグスクロール](http://terai.xrea.jp/Swing/DragScrollLayer.html)

<!-- dummy comment line for breaking list -->

### コメント
