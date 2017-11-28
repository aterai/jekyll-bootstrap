---
layout: post
category: swing
folder: ResizableComponents
title: JComponentをマウスで移動、リサイズ
tags: [JLayeredPane, MouseListener, MouseMotionListener, JComponent]
author: aterai
pubdate: 2008-05-19T13:41:14+09:00
description: JLayeredPaneに、マウスで移動、リサイズ可能なコンポーネントを追加します。
image: https://lh4.googleusercontent.com/_9Z4BYR88imo/TQTRw-M85QI/AAAAAAAAAhs/BFyVP2IYoak/s800/ResizableComponents.png
comments: true
---
## 概要
`JLayeredPane`に、マウスで移動、リサイズ可能なコンポーネントを追加します。

{% download https://lh4.googleusercontent.com/_9Z4BYR88imo/TQTRw-M85QI/AAAAAAAAAhs/BFyVP2IYoak/s800/ResizableComponents.png %}

## サンプルコード
<pre class="prettyprint"><code>@Override public void mouseDragged(MouseEvent e) {
  if (startPos == null || startingBounds == null) return;
  Point p = SwingUtilities.convertPoint(e.getComponent(), e.getX(), e.getY(), null);
  int deltaX = startPos.x - p.x;
  int deltaY = startPos.y - p.y;
  int newX = getX();
  int newY = getY();
  int newW = getWidth();
  int newH = getHeight();

  JComponent parent = (JComponent) getParent();
  Rectangle parentBounds = parent.getBounds();
  Dimension min = new Dimension(50, 50);
  Dimension max = new Dimension(500, 500);

  switch (cursor) {
    case Cursor.N_RESIZE_CURSOR: {
      if (startingBounds.height + deltaY &lt; min.height) {
        deltaY = -(startingBounds.height - min.height);
      } else if (startingBounds.height + deltaY &gt; max.height) {
        deltaY = max.height - startingBounds.height;
      }
      if (startingBounds.y - deltaY &lt; 0) {
        deltaY = startingBounds.y;
      }
      newX = startingBounds.x;
      newY = startingBounds.y - deltaY;
      newW = startingBounds.width;
      newH = startingBounds.height + deltaY;
      break;
    }
    case Cursor.NE_RESIZE_CURSOR: {
      if (startingBounds.height + deltaY &lt; min.height) {
        deltaY = -(startingBounds.height - min.height);
//...
</code></pre>

## 解説
上記のサンプルでは、ツールバーやポップアップメニューから、移動、リサイズ可能な`JTable`や`JTree`を`JLayeredPane`(`JLayeredPane`のデフォルトレイアウトマネージャは`null`)に追加することができます。

リサイズボーダーの描画などは、[Resizable Components - Santhosh Kumar's Weblog](http://www.jroller.com/santhosh/entry/resizable_components)から、マウスのドラッグによる移動、リサイズの最大値、最小値の制限などは、`%JAVA_HOME%/src/javax/swing/plaf/basic/BasicInternalFrameUI.java`からの引用です。

- - - -
`JDK1.5`では、`JLayeredPane#setComponentPopupMenu`を使う場合、以下のようにダミーのマウスリスナーなどを追加しておく必要があります。

<pre class="prettyprint"><code>layer.setComponentPopupMenu(new MyPopupMenu());
layer.addMouseListener(new MouseAdapter() {});
</code></pre>

- - - -
`JDK1.6`では、背面にある`JTable`のヘッダが前面にロールオーバーしてしまいます。

![screenshot](https://lh4.googleusercontent.com/_9Z4BYR88imo/TQTRzAZnaVI/AAAAAAAAAhw/t9TWz3YYv6U/s800/ResizableComponents1.png)

## 参考リンク
- [Resizable Components - Santhosh Kumar's Weblog](http://www.jroller.com/santhosh/entry/resizable_components)

<!-- dummy comment line for breaking list -->

## コメント
