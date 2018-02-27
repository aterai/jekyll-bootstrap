---
layout: post
category: swing
folder: EditableComboCellEditor
title: JTableのセルエディタとして編集追加可能なJComboBoxを使用する
tags: [JTable, TableCellEditor, JComboBox, DefaultComboBoxModel]
author: aterai
pubdate: 2016-07-25T00:38:48+09:00
description: JTableのセルエディタとして編集可能なJComboBoxを適用し、セルの値の追加などを行います。
image: https://lh3.googleusercontent.com/-qEx3-yOwZzY/V5Td7p-XE0I/AAAAAAAAOeI/Ac2sgZB4y1E7pW5x33cb_KxNhv1x9AN5QCCo/s800/EditableComboCellEditor.png
hreflang:
    href: https://java-swing-tips.blogspot.com/2016/08/use-editable-jcombobox-as.html
    lang: en
comments: true
---
## 概要
`JTable`のセルエディタとして編集可能な`JComboBox`を適用し、セルの値の追加などを行います。

{% download https://lh3.googleusercontent.com/-qEx3-yOwZzY/V5Td7p-XE0I/AAAAAAAAOeI/Ac2sgZB4y1E7pW5x33cb_KxNhv1x9AN5QCCo/s800/EditableComboCellEditor.png %}

## サンプルコード
<pre class="prettyprint"><code>class ComboCellEditor extends AbstractCellEditor implements TableCellEditor {
  private final JComboBox&lt;String&gt; combo = new JComboBox&lt;&gt;();
  protected ComboCellEditor() {
    super();
    combo.setEditable(true);
    combo.addActionListener(e -&gt; fireEditingStopped());
  }
  @Override public Component getTableCellEditorComponent(
      JTable table, Object value, boolean isSelected, int row, int column) {
    if (value instanceof ComboBoxModel) {
      @SuppressWarnings("unchecked")
      ComboBoxModel&lt;String&gt; m = (ComboBoxModel&lt;String&gt;) value;
      combo.setModel(m);
    }
    return combo;
  }
  @Override public Object getCellEditorValue() {
    @SuppressWarnings("unchecked")
    DefaultComboBoxModel&lt;String&gt; m = (DefaultComboBoxModel&lt;String&gt;) combo.getModel();
    if (combo.isEditable()) {
      String str = Objects.toString(combo.getEditor().getItem(), "");
      if (!str.isEmpty() &amp;&amp; m.getIndexOf(str) &lt; 0) {
        m.insertElementAt(str, 0);
        combo.setSelectedIndex(0);
      }
    }
    return m;
  }
}
</code></pre>

## 解説
上記のサンプルでは、`JComboBox#setEditable(true)`で編集可能にした`JComboBox`を`JTable`のセルエディタに設定し、セルの値を追加したり編集したりすることを可能にしています。[JTableのCellEditorにJComboBoxを設定](https://ateraimemo.com/Swing/ComboCellEditor.html)で使用しているデフォルトの`ComboBoxCellEditor`とは違い、各行で`JComboBox`の所有するアイテムが異なり、またそれらのアイテムの選択位置も保持する必要があるため、`TableModel`には`DefaultComboBoxModel`をモデルデータとして保存しています。

## 参考リンク
- [JTableのCellEditorにJComboBoxを設定](https://ateraimemo.com/Swing/ComboCellEditor.html)

<!-- dummy comment line for breaking list -->

## コメント
