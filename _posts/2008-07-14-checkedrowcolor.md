---
layout: post
title: JTableのセルにJCheckBoxを表示して行背景色を変更
category: swing
folder: CheckedRowColor
tags: [JTable, JCheckBox, TableModelListener, TableCellRenderer, TableCellEditor]
author: aterai
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2008-07-14

## JTableのセルにJCheckBoxを表示して行背景色を変更
`JTable`のセルに表示されている`JCheckBox`がチェックされていれば、その行の背景色を変更します。

- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](http://lh6.ggpht.com/_9Z4BYR88imo/TQTI7wkSMbI/AAAAAAAAATk/uGVLWCqLJUI/s800/CheckedRowColor.png)

### サンプルコード
<pre class="prettyprint"><code>JTable table = new JTable(model) {
  @Override public Component prepareEditor(
        TableCellEditor editor, int row, int column) {
    Component cmp = super.prepareEditor(editor, row, column);
    if(convertColumnIndexToModel(column) == BOOLEAN_COLUMN) {
      JCheckBox c = (JCheckBox)cmp;
      c.setBackground(c.isSelected()? Color.ORANGE:getBackground());
    }
    return cmp;
  }
  @Override public Component prepareRenderer(
        TableCellRenderer renderer, int row, int column) {
    Component c = super.prepareRenderer(renderer, row, column);
    Boolean isChecked = (Boolean) model.getValueAt(
      convertRowIndexToModel(row), BOOLEAN_COLUMN);
    c.setForeground(getForeground());
    c.setBackground(isChecked? Color.ORANGE:getBackground());
    return c;
  }
};
</code></pre>

### 解説
上記のサンプルでは、`JTable`の`prepareEditor`、`prepareRenderer`をオーバーライドしてセルエディタや行の背景色を変更しています。

- - - -
`TableModelListener`でモデルが更新されると、`table.repaint()`で全体を再描画するのではなく、更新の対象になっている行だけを、以下のように再描画しています。

<pre class="prettyprint"><code>model.addTableModelListener(new TableModelListener() {
  @Override public void tableChanged(TableModelEvent e) {
    if(e.getType()==TableModelEvent.UPDATE) {
      //rowRepaint(table, table.convertRowIndexToView(e.getFirstRow()));
      Rectangle r = table.getCellRect(table.convertRowIndexToView(e.getFirstRow()), 0, true);
      r.width  = table.getWidth();
      table.repaint(r);
      //すこし無駄？: table.repaint();
    }
  }
});
</code></pre>


### 参考リンク
- [JTable-Row color issue | Oracle Forums](https://forums.oracle.com/message/5745962)

<!-- dummy comment line for breaking list -->

### コメント
- ごちそうさまでした。 -- [tanuchan](http://terai.xrea.jp/tanuchan.html) 2009-12-14 (Mon) 04:22:08
    - まいどありです。 -- [aterai](http://terai.xrea.jp/aterai.html) 2009-12-16 (水) 21:25:57
- メモ: [Bug ID: 6711682 JCheckBox in JTable: checkbox doesn't alaways respond to the first mouse click](http://bugs.sun.com/bugdatabase/view_bug.do?bug_id=6711682) -- [aterai](http://terai.xrea.jp/aterai.html) 2010-07-26 (月) 14:18:03

<!-- dummy comment line for breaking list -->

