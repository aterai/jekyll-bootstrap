---
layout: post
category: swing
folder: MouseOverPainter
title: JTextAreaの行をマウスでロールオーバー表示
tags: [JTextArea, MouseListener, MouseMotionListener]
author: aterai
pubdate: 2006-09-25T03:59:45+09:00
description: JTextAreaのマウスカーソルがある行をロールオーバー表示します。
image: https://lh3.googleusercontent.com/_9Z4BYR88imo/TQTQFUVNyQI/AAAAAAAAAfA/cTsyoFPSNEg/s800/MouseOverPainter.png
comments: true
---
## 概要
`JTextArea`のマウスカーソルがある行をロールオーバー表示します。

{% download https://lh3.googleusercontent.com/_9Z4BYR88imo/TQTQFUVNyQI/AAAAAAAAAfA/cTsyoFPSNEg/s800/MouseOverPainter.png %}

## サンプルコード
<pre class="prettyprint"><code>class HighlightCursorTextArea extends JTextArea {
  private static final Color LINE_COLOR = new Color(250, 250, 220);
  private int rollOverRowIndex = -1;
  private MouseAdapter rolloverHandler;

  @Override public void updateUI() {
    removeMouseMotionListener(rolloverHandler);
    removeMouseListener(rolloverHandler);
    super.updateUI();
    setOpaque(false);
    setBackground(new Color(0x0, true)); // Nimbus
    rolloverHandler = new RollOverListener();
    addMouseMotionListener(rolloverHandler);
    addMouseListener(rolloverHandler);
  }
  @Override protected void paintComponent(Graphics g) {
    Graphics2D g2 = (Graphics2D) g.create();
    Insets i = getInsets();
    int h = g2.getFontMetrics().getHeight();
    int y = rollOverRowIndex * h + i.top;
    g2.setPaint(LINE_COLOR);
    g2.fillRect(i.left, y, getSize().width - i.left - i.right, h);
    g2.dispose();
    super.paintComponent(g);
  }
  private class RollOverListener extends MouseAdapter {
    @Override public void mouseExited(MouseEvent e) {
      rollOverRowIndex = -1;
      repaint();
    }
    @Override public void mouseMoved(MouseEvent e) {
      int row = getLineAtPoint(e.getPoint());
      if (row != rollOverRowIndex) {
        rollOverRowIndex = row;
        repaint();
      }
    }
    public int getLineAtPoint(Point pt) {
      Element root = getDocument().getDefaultRootElement();
      return root.getElementIndex(viewToModel(pt));
    }
  }
}
</code></pre>

## 解説
上記のサンプルでは、`MouseAdapter`を継承した`RollOverListener`でマウスカーソルのある行を記憶し、`JTextArea#paintComponent`メソッドをオーバーライドしてその行の背景色を変更しています。

## 参考リンク
- [Element#getElementIndex(...) (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/javax/swing/text/Element.html#getElementIndex-int-)

<!-- dummy comment line for breaking list -->

## コメント
