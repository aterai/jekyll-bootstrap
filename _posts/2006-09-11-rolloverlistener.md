---
layout: post
category: swing
folder: RollOverListener
title: JListのセルをカーソル移動でロールオーバー
tags: [JList, MouseListener, MouseMotionListener]
author: aterai
pubdate: 2006-09-11T09:10:47+09:00
description: JListでマウスカーソルの下にあるセルをハイライト表示します。
image: https://lh4.googleusercontent.com/_9Z4BYR88imo/TQTSE8rUioI/AAAAAAAAAiM/4EMPSFpuBVo/s800/RollOverListener.png
comments: true
---
## 概要
`JList`でマウスカーソルの下にあるセルをハイライト表示します。

{% download https://lh4.googleusercontent.com/_9Z4BYR88imo/TQTSE8rUioI/AAAAAAAAAiM/4EMPSFpuBVo/s800/RollOverListener.png %}

## サンプルコード
<pre class="prettyprint"><code>class RollOverList&lt;E&gt; extends JList&lt;E&gt; {
  private static final Color ROLLOVERBACKGROUND = new Color(220, 240, 255);
  private transient RollOverListener rollOverListener;
  public RollOverList(ListModel&lt;E&gt; model) {
    super(model);
  }
  @Override public void updateUI() {
    if (rollOverListener != null) {
      removeMouseListener(rollOverListener);
      removeMouseMotionListener(rollOverListener);
    }
    setSelectionBackground(null); //Nimbus
    super.updateUI();
    EventQueue.invokeLater(new Runnable() {
      @Override public void run() {
        rollOverListener = new RollOverListener();
        addMouseMotionListener(rollOverListener);
        addMouseListener(rollOverListener);
        setCellRenderer(new RollOverCellRenderer());
      }
    });
  }
  private class RollOverCellRenderer extends DefaultListCellRenderer {
    @Override public Component getListCellRendererComponent(
        JList list, Object value, int index,
        boolean isSelected, boolean cellHasFocus) {
      Component c = super.getListCellRendererComponent(
          list, value, index, isSelected, cellHasFocus);
      if (rollOverListener != null
          &amp;&amp; index == rollOverListener.rollOverRowIndex) {
        c.setBackground(ROLLOVERBACKGROUND);
        if (isSelected) {
          c.setForeground(Color.BLACK);
        }
      }
      return c;
    }
  }
  private class RollOverListener extends MouseAdapter {
    private int rollOverRowIndex = -1;
    @Override public void mouseExited(MouseEvent e) {
      rollOverRowIndex = -1;
      repaint();
    }
    @Override public void mouseMoved(MouseEvent e) {
      int row = locationToIndex(e.getPoint());
      if (row != rollOverRowIndex) {
        Rectangle rect = getCellBounds(row, row);
        if (rollOverRowIndex &gt;= 0) {
          rect.add(getCellBounds(rollOverRowIndex, rollOverRowIndex));
        }
        rollOverRowIndex = row;
        repaint(rect);
      }
    }
  }
}
</code></pre>

## 解説
`MouseInputAdapter`をオーバーライドして、マウスカーソルのあるセルを記憶し、`JList`をリペイントしてそのセルの背景色などを変更しています。

## 参考リンク
- [Swing - Highlight JTable rows on rollover](https://community.oracle.com/thread/1389010)
- [JTableのセルのハイライト](http://ateraimemo.com/Swing/CellHighlight.html)

<!-- dummy comment line for breaking list -->

## コメント
