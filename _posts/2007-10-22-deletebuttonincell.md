---
layout: post
title: JTableのセルにJButtonを追加して行削除
category: swing
folder: DeleteButtonInCell
tags: [JTable, JButton, TableCellRenderer, TableCellEditor, ActionListener]
author: aterai
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2007-10-22

## JTableのセルにJButtonを追加して行削除
`JTable`のセルに`JButton`を追加し、クリックされたらその行を削除します。

- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](http://lh4.ggpht.com/_9Z4BYR88imo/TQTKsRqqqeI/AAAAAAAAAWY/X0y-Ph7jngA/s800/DeleteButtonInCell.png)

### サンプルコード
<pre class="prettyprint"><code>class DeleteButton extends JButton {
  @Override public void updateUI() {
    super.updateUI();
    setBorder(BorderFactory.createEmptyBorder());
    setFocusable(false);
    setRolloverEnabled(false);
    setText("X");
  }
}
</code></pre>
<pre class="prettyprint"><code>class DeleteButtonRenderer extends DeleteButton implements TableCellRenderer {
  public DeleteButtonRenderer() {
    super();
    setName("Table.cellRenderer");
  }
  @Override public Component getTableCellRendererComponent(JTable table,
      Object value, boolean isSelected, boolean hasFocus, int row, int column) {
    return this;
  }
}
</code></pre>
<pre class="prettyprint"><code>class DeleteButtonEditor extends DeleteButton implements TableCellEditor {
  public DeleteButtonEditor(final JTable table) {
    super();
    addActionListener(new ActionListener() {
      @Override public void actionPerformed(ActionEvent e) {
        int row = table.convertRowIndexToModel(table.getEditingRow());
        fireEditingStopped();
        ((DefaultTableModel)table.getModel()).removeRow(row);
      }
    });
  }
  @Override public Component getTableCellEditorComponent(JTable table,
      Object value, boolean isSelected, int row, int column) {
    return this;
  }
  @Override public Object getCellEditorValue() {
    return "";
  }
  //Copid from AbstractCellEditor
  //protected EventListenerList listenerList = new EventListenerList();
  //transient protected ChangeEvent changeEvent = null;
//......
</code></pre>

### 解説
~~上記のサンプルでは、ボタンがクリックされたときの削除自体は、`JTable`に追加したマウスリスナーで行っており、セルエディタやセルレンダラーに使っている`JButton`は表示のためのダミーです。~~

- セルレンダラーに使っている`JButton`は表示のためのダミー
- セルエディタとして使用する`JButton`に`ActionListener`を追加し、クリックされたら`AbstractCellEditor`からコピーした`fireEditingStopped()`メソッドで編集を終了し、`TableModel`から行を削除
    - セルレンダラ、セルエディタがコンポーネント(もしくは`DefaultCellEditor`)を継承していないと、`JTable`の`LookAndFeel`を変更てもセルレンダラ、セルエディタの`updateUI()`が呼ばれない
        - `JTable#updateUI()`、`Java 1.6.0`の`JTable#updateSubComponentUI(...)`、`Java 1.7.0`の`SwingUtilities#updateRendererOrEditorUI(Object)`を参照
    - `AbstractCellEditor`を継承していても`updateUI()`は呼ばれない、`DefaultCellEditor`は継承しづらい…

<!-- dummy comment line for breaking list -->

### 参考リンク
- [JButton inside JTable Cell | Oracle Forums](https://forums.oracle.com/message/5729360)
- [JTableの行を追加、削除](http://terai.xrea.jp/Swing/AddRow.html)
- [JTableの行を全削除](http://terai.xrea.jp/Swing/ClearTable.html)
- [JTableのセルに複数のJButtonを配置する](http://terai.xrea.jp/Swing/MultipleButtonsInTableCell.html)
- [JTableのセルにHyperlinkを表示](http://terai.xrea.jp/Swing/HyperlinkInTableCell.html)

<!-- dummy comment line for breaking list -->

### コメント
- ボタンのセル内でマウスを移動しても削除するように変更。 -- [aterai](http://terai.xrea.jp/aterai.html) 2008-03-28 (金) 16:59:11
    - メモ: `0`行目のボタンをクリックし、真上のヘッダ上でリリースしても削除できる -> [Bug ID: 6291631 JTable: rowAtPoint returns 0 for negative y](http://bugs.sun.com/bugdatabase/view_bug.do?bug_id=6291631) (追記: このバグは未修正になっているけど、`JDK 1.6, 1.7`などのソースではコメントにある修正が追加されている) -- [aterai](http://terai.xrea.jp/aterai.html) 2008-03-28 (金) 17:21:10

<!-- dummy comment line for breaking list -->

<pre class="prettyprint"><code>//上記のBug Databaseにある回避方法
JTable table = new JTable(model) {
  @Override public int rowAtPoint(Point pt) {
    return (pt.y&lt;0)?-1:super.rowAtPoint(pt);
  }
};
</code></pre>

- テスト -- [aterai](http://terai.xrea.jp/aterai.html) 2009-09-27 (日) 01:34:58
    - [JTableのセルに複数のJButtonを配置する](http://terai.xrea.jp/Swing/MultipleButtonsInTableCell.html)に移動。

<!-- dummy comment line for breaking list -->
