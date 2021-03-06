---
layout: post
category: swing
folder: DragScrollLayer
title: JScrollPane内にある複数Componentを配置したJPanelをJLayerを使ってドラッグスクロール
tags: [JScrollPane, JPanel, JLayer]
author: aterai
pubdate: 2013-08-05T11:49:22+09:00
description: 複数のネストしたComponentを配置したJPanelのドラッグイベントを、JScrollPaneをラップしたJLayerで受け取ってスクロール可能にします。
image: https://lh5.googleusercontent.com/-5zBF0JOr6kM/UfuiEj7Do7I/AAAAAAAABxg/7tKYnrOl9eo/s800/DragScrollLayer.png
comments: true
---
## 概要
複数のネストした`Component`を配置した`JPanel`のドラッグイベントを、`JScrollPane`をラップした`JLayer`で受け取ってスクロール可能にします。

{% download https://lh5.googleusercontent.com/-5zBF0JOr6kM/UfuiEj7Do7I/AAAAAAAABxg/7tKYnrOl9eo/s800/DragScrollLayer.png %}

## サンプルコード
<pre class="prettyprint"><code>class DragScrollLayerUI extends LayerUI&lt;JScrollPane&gt; {
  private final Point pp = new Point();

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
      MouseEvent e, JLayer&lt;? extends JScrollPane&gt; l) {
    Component c = e.getComponent();
    if (c instanceof JScrollBar || c instanceof JSlider) {
      return;
    }
    if (e.getID() == MouseEvent.MOUSE_PRESSED) {
      JViewport vport = l.getView().getViewport();
      Point cp = SwingUtilities.convertPoint(c, e.getPoint(), vport);
      pp.setLocation(cp);
    }
  }

  @Override protected void processMouseMotionEvent(
      MouseEvent e, JLayer&lt;? extends JScrollPane&gt; l) {
    Component c = e.getComponent();
    if (c instanceof JScrollBar || c instanceof JSlider) {
      return;
    }
    if (e.getID() == MouseEvent.MOUSE_DRAGGED) {
      JViewport vport = l.getView().getViewport();
      JComponent cmp = (JComponent) vport.getView();
      Point cp = SwingUtilities.convertPoint(c, e.getPoint(), vport);
      Point vp = vport.getViewPosition();
      vp.translate(pp.x - cp.x, pp.y - cp.y);
      cmp.scrollRectToVisible(new Rectangle(vp, vport.getSize()));
      pp.setLocation(cp);
    }
  }
}
</code></pre>

## 解説
- 左: `DragScrollListener`
    - [JTreeの余白をドラッグしてスクロール](https://ateraimemo.com/Swing/TreeDragScroll.html)
    - このリスナーを追加した一つの`Component`をドラッグしてスクロールが可能
    - `JPanel`を掴んでのスクロールが実行可能だが、その子コンポーネントの`JTabbedPane`などをドラッグしてもスクロールは不可
- 右: `DragScrollLayer`
    - すべての下位コンポーネントの`MouseEvent`をキャッチするよう`JLayer#setLayerEventMask(...)`と設定した`JLayer`を作成
    - この`JLayer`で`JScrollPane`をラップし、子にマウスイベントを消費するコンポーネントが存在する場合でも、ビューの`JPanel`をドラッグに応じてスクロール
    - `JScrollBar`や`JSlider`のように、ノブのドラッグを使用するコンポーネントは二重にスクロールしてしまうので除外

<!-- dummy comment line for breaking list -->

## 参考リンク
- [Java Swing Tips: Mouse Dragging ViewPort Scroll](https://java-swing-tips.blogspot.com/2009/03/mouse-dragging-viewport-scroll.html)
- [JTreeの余白をドラッグしてスクロール](https://ateraimemo.com/Swing/TreeDragScroll.html)
- [JScrollPaneのViewportをマウスで掴んでスクロール](https://ateraimemo.com/Swing/HandScroll.html)

<!-- dummy comment line for breaking list -->

## コメント
