---
layout: post
title: JTextAreaの行をマウスでロールオーバー表示
category: swing
folder: MouseOverPainter
tags: [JTextArea, MouseListener, MouseMotionListener]
author: aterai
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2006-09-25

## JTextAreaの行をマウスでロールオーバー表示
`JTextArea`のマウスカーソルがある行をロールオーバー表示します。

- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](http://lh3.ggpht.com/_9Z4BYR88imo/TQTQFUVNyQI/AAAAAAAAAfA/cTsyoFPSNEg/s800/MouseOverPainter.png)

### サンプルコード
<pre class="prettyprint"><code>class HighlightCursorTextArea extends JTextArea {
  public HighlightCursorTextArea() {
    super();
    setOpaque(false);
    RollOverListener rol = new RollOverListener();
    addMouseMotionListener(rol);
    addMouseListener(rol);
  }
  private final Color linecolor = new Color(250,250,220);
  @Override protected void paintComponent(Graphics g) {
    Graphics2D g2 = (Graphics2D)g;
    Insets i = getInsets();
    int h = g2.getFontMetrics().getHeight();
    int y = rollOverRowIndex*h+i.top;
    g2.setPaint(linecolor);
    g2.fillRect(i.left, y, getSize().width-i.left-i.right, h);
    super.paintComponent(g);
  }
  private int rollOverRowIndex = -1;
  private class RollOverListener extends MouseInputAdapter {
    @Override public void mouseExited(MouseEvent e) {
      rollOverRowIndex = -1;
      repaint();
    }
    @Override public void mouseMoved(MouseEvent e) {
      int row = getLineAtPoint(e.getPoint());
      if(row != rollOverRowIndex) {
        rollOverRowIndex = row;
        repaint();
      }
    }
    @Override public int getLineAtPoint(Point pt) {
      Element root = getDocument().getDefaultRootElement();
      return root.getElementIndex(viewToModel(pt));
    }
  }
}
</code></pre>

### 解説
`MouseInputAdapter`を継承した`RollOverListener`で、マウスカーソルのある行を記憶し、`JTextArea#paintComponent`メソッドをオーバーライドして、その行の背景に色を付けています。

### コメント
