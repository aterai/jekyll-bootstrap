---
layout: post
category: swing
folder: DiagonallySplitCellCalendar
title: JTableのセルを斜めに分割する
tags: [JTable, JLayer, JLabel]
author: aterai
pubdate: 2020-06-01T03:09:34+09:00
description: JTableのセルレンダラーにJLayerで直線を描画して斜め分断セルを表示します。
image: https://drive.google.com/uc?id=19GKh0Ts86Zd4J0mjJTp1pmNkOnrcURBy
hreflang:
    href: https://java-swing-tips.blogspot.com/2020/06/create-month-calendar-with-diagonally.html
    lang: en
comments: true
---
## 概要
`JTable`のセルレンダラーに`JLayer`で直線を描画して斜め分断セルを表示します。

{% download https://drive.google.com/uc?id=19GKh0Ts86Zd4J0mjJTp1pmNkOnrcURBy %}

## サンプルコード
<pre class="prettyprint"><code>private class CalendarTableRenderer extends DefaultTableCellRenderer {
  private final JPanel p = new JPanel();

  @Override public Component getTableCellRendererComponent(
        JTable table, Object value, boolean selected, boolean focused,
        int row, int column) {
    JLabel c = (JLabel) super.getTableCellRendererComponent(
        table, value, selected, focused, row, column);
    if (value instanceof LocalDate) {
      LocalDate d = (LocalDate) value;
      c.setText(Objects.toString(d.getDayOfMonth()));
      c.setVerticalAlignment(SwingConstants.TOP);
      c.setHorizontalAlignment(SwingConstants.LEFT);
      updateCellWeekColor(d, c, c);

      LocalDate nextWeekDay = d.plusDays(7);
      boolean isLastRow = row == table.getModel().getRowCount() - 1;
      if (isLastRow &amp;&amp;
          YearMonth.from(nextWeekDay).equals(YearMonth.from(getCurrentLocalDate()))) {
        JLabel sub = new JLabel(Objects.toString(nextWeekDay.getDayOfMonth()));
        sub.setBorder(BorderFactory.createEmptyBorder(1, 1, 1, 1));
        sub.setOpaque(false);
        sub.setVerticalAlignment(SwingConstants.BOTTOM);
        sub.setHorizontalAlignment(SwingConstants.RIGHT);

        p.removeAll();
        p.setLayout(new BorderLayout());
        p.add(sub, BorderLayout.SOUTH);
        p.add(c, BorderLayout.NORTH);
        p.setBorder(c.getBorder());
        c.setBorder(BorderFactory.createEmptyBorder(1, 1, 1, 1));

        updateCellWeekColor(d, sub, p);
        return new JLayer&lt;&gt;(p, new DiagonallySplitCellLayerUI());
      }
    }
    return c;
  }
  // ...
</code></pre>

## 解説
上記のサンプルでは、月カレンダーで`6`週目になる日を前の`5`週目の同じ曜日のセルを斜め分割してまとめて表示しています。

- `DefaultTableModel#getRowCount()`が常に`5`を返すようオーバーライドして、月カレンダーが`5`週分のみ表示するよう設定
- `5`週目(`row==4`)を表示するセルレンダラーで対象日の`7`日後が今月の場合、`BorderLayout`を設定した`JPanel`に対象日用の`JLabel`を`BorderLayout.NORTH`、`7`日後の日付を表示するための別`JLabel`を`BorderLayout.SOUTH`で追加
- この`JPanel`に斜め線を表示する`JLayer`を作成してセルレンダラーとして使用

<!-- dummy comment line for breaking list -->

<pre class="prettyprint"><code>class DiagonallySplitCellLayerUI extends LayerUI&lt;JPanel&gt; {
  @Override public void paint(Graphics g, JComponent c) {
    super.paint(g, c);
    if (c instanceof JLayer) {
      Graphics2D g2 = (Graphics2D) g.create();
      g2.setRenderingHint(RenderingHints.KEY_ANTIALIASING, RenderingHints.VALUE_ANTIALIAS_ON);
      g2.setPaint(UIManager.getColor("Table.gridColor"));
      g2.drawLine(c.getWidth(), 0, 0, c.getHeight());
      g2.dispose();
    }
  }
}
</code></pre>

## 参考リンク
- [JTableにLocaleを考慮したLocalDateを適用してカレンダーを表示する](https://ateraimemo.com/Swing/CalendarViewTable.html)
- [JTableの行高がJViewportの高さに合うまで調整する](https://ateraimemo.com/Swing/AdjustRowHeightFillsViewport.html)

<!-- dummy comment line for breaking list -->

## コメント
