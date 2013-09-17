---
layout: post
title: JListのセルをカーソル移動でロールオーバー
category: swing
folder: RollOverListener
tags: [JList, MouseListener, MouseMotionListener]
author: aterai
comments: true
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2006-09-11

## JListのセルをカーソル移動でロールオーバー
`JList`でマウスカーソルの下にあるセルをハイライト表示します。

- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](https://lh4.googleusercontent.com/_9Z4BYR88imo/TQTSE8rUioI/AAAAAAAAAiM/4EMPSFpuBVo/s800/RollOverListener.png)

### サンプルコード
<pre class="prettyprint"><code>class RollOverList extends JList {
  private int rollOverRowIndex = -1;
  public RollOverList() {
    super();
    RollOverListener rol = new RollOverListener();
    addMouseMotionListener(rol);
    addMouseListener(rol);
    setCellRenderer(new RollOverCellRenderer());
  }
  private class RollOverCellRenderer extends DefaultListCellRenderer{
    @Override public Component getListCellRendererComponent(
            JList list, Object value, int index,
            boolean isSelected, boolean cellHasFocus) {
      Component c = super.getListCellRendererComponent(
          list, value, index, isSelected, cellHasFocus);
      if(index == rollOverRowIndex) {
        c.setBackground(new Color(220,240,255));
        if(isSelected) c.setForeground(Color.BLACK);
      }
      return c;
    }
  }
  private class RollOverListener extends MouseInputAdapter {
    @Override public void mouseExited(MouseEvent e) {
      rollOverRowIndex = -1;
      repaint();
    }
    @Override public void mouseMoved(MouseEvent e) {
      int row = locationToIndex(e.getPoint());
      if(row != rollOverRowIndex) {
        rollOverRowIndex = row;
        repaint();
      }
    }
  }
}
</code></pre>

### 解説
`MouseInputAdapter`をオーバーライドして、マウスカーソルのあるセルを記憶し、`JList`をリペイントしてそのセルの背景色などを変更しています。

### 参考リンク
- [Swing - Highlight JTable rows on rollover](https://forums.oracle.com/thread/1389010)
- [JTableのセルのハイライト](http://terai.xrea.jp/Swing/CellHighlight.html)

<!-- dummy comment line for breaking list -->

### コメント
