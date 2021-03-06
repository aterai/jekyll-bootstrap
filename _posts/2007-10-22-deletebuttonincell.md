---
layout: post
category: swing
folder: DeleteButtonInCell
title: JTableのセルにJButtonを追加して行削除
tags: [JTable, JButton, TableCellRenderer, TableCellEditor, ActionListener]
author: aterai
pubdate: 2007-10-22T07:55:05+09:00
description: JTableのセルにJButtonを追加し、クリックされたらその行を削除します。
image: https://lh4.googleusercontent.com/_9Z4BYR88imo/TQTKsRqqqeI/AAAAAAAAAWY/X0y-Ph7jngA/s800/DeleteButtonInCell.png
comments: true
---
## 概要
`JTable`のセルに`JButton`を追加し、クリックされたらその行を削除します。

{% download https://lh4.googleusercontent.com/_9Z4BYR88imo/TQTKsRqqqeI/AAAAAAAAAWY/X0y-Ph7jngA/s800/DeleteButtonInCell.png %}

## サンプルコード
<pre class="prettyprint"><code>class DeleteButton extends JButton {
  @Override public void updateUI() {
    super.updateUI();
    setBorder(BorderFactory.createEmptyBorder());
    setFocusable(false);
    setRolloverEnabled(false);
    setText("X");
  }
}

class DeleteButtonRenderer extends DeleteButton implements TableCellRenderer {
  public DeleteButtonRenderer() {
    super();
    setName("Table.cellRenderer");
  }
  @Override public Component getTableCellRendererComponent(JTable table,
      Object value, boolean isSelected, boolean hasFocus, int row, int column) {
    return this;
  }
}

class DeleteButtonEditor extends DeleteButton implements TableCellEditor {
  public DeleteButtonEditor(final JTable table) {
    super();
    addActionListener(new ActionListener() {
      @Override public void actionPerformed(ActionEvent e) {
        int row = table.convertRowIndexToModel(table.getEditingRow());
        fireEditingStopped();
        ((DefaultTableModel) table.getModel()).removeRow(row);
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
  // Copied from AbstractCellEditor
  // protected EventListenerList listenerList = new EventListenerList();
  // transient protected ChangeEvent changeEvent = null;
// ...
</code></pre>

## 解説
~~上記のサンプルでは、ボタンがクリックされたときの削除自体は、`JTable`に追加したマウスリスナーで行っており、セルエディタやセルレンダラーに使っている`JButton`は表示のためのダミーです。~~

- セルレンダラーに使っている`JButton`は表示のためのダミー
- セルエディタとして使用する`JButton`に`ActionListener`を追加し、この`JButton`がクリックされたら`AbstractCellEditor`からコピーした`fireEditingStopped()`メソッドでセルの編集を終了し、`TableModel`から対象行を削除
    - セルレンダラー、セルエディタがコンポーネント(もしくは`DefaultCellEditor`)を継承していないと、`JTable`の`LookAndFeel`を変更てもセルレンダラー、セルエディタの`updateUI()`が呼ばれない
        - `JTable#updateUI()`、`Java 1.6.0`の`JTable#updateSubComponentUI(...)`、`Java 1.7.0`の`SwingUtilities#updateRendererOrEditorUI(Object)`を参照
    - `AbstractCellEditor`を継承していても`updateUI()`は呼ばれない、`DefaultCellEditor`は継承しづらい…

<!-- dummy comment line for breaking list -->

## 参考リンク
- [Swing - JButton inside JTable Cell](https://community.oracle.com/thread/1357728)
- [JTableの行を追加、削除](https://ateraimemo.com/Swing/AddRow.html)
- [JTableの行を全削除](https://ateraimemo.com/Swing/ClearTable.html)
- [JTableのセルに複数のJButtonを配置する](https://ateraimemo.com/Swing/MultipleButtonsInTableCell.html)
- [JTableのセルにHyperlinkを表示](https://ateraimemo.com/Swing/HyperlinkInTableCell.html)

<!-- dummy comment line for breaking list -->

## コメント
- ボタンのセル内でマウスを移動しても削除するように変更。 -- *aterai* 2008-03-28 (金) 16:59:11
    - メモ: ~~`0`行目のボタンをクリックし、真上のヘッダ上でリリースしても削除可能~~ 修正済み: [Bug ID: 6291631 JTable: rowAtPoint returns 0 for negative y](https://bugs.openjdk.java.net/browse/JDK-6291631) (追記: このバグは未修正になっているけど、`JDK 1.6, 1.7`などのソースではコメントにある修正が追加されている) -- *aterai* 2008-03-28 (金) 17:21:10

<!-- dummy comment line for breaking list -->

<pre class="prettyprint"><code>//上記のBug Databaseにある回避方法
JTable table = new JTable(model) {
  @Override public int rowAtPoint(Point pt) {
    return (pt.y &lt; 0) ? -1 : super.rowAtPoint(pt);
  }
};
</code></pre>

- テスト -- *aterai* 2009-09-27 (日) 01:34:58
    - [JTableのセルに複数のJButtonを配置する](https://ateraimemo.com/Swing/MultipleButtonsInTableCell.html)に移動。 -- *aterai* 2009-10-05 (日) 01:34:58

<!-- dummy comment line for breaking list -->
