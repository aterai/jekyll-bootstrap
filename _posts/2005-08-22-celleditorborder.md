---
layout: post
title: CellEditorのBorderを変更
category: swing
folder: CellEditorBorder
tags: [JTable, TableCellEditor, Border]
author: aterai
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2005-08-22

## CellEditorのBorderを変更
`JTable`の`CellEditor`に`Border`を設定します。

- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](http://lh3.ggpht.com/_9Z4BYR88imo/TQTIiyFXk2I/AAAAAAAAAS8/Dgu1EqDMma4/s800/CellEditorBorder.png)

### サンプルコード
<pre class="prettyprint"><code>JTextField field = new JTextField();
field.setBorder(BorderFactory.createLineBorder(Color.RED, 2));
table.setDefaultEditor(Object.class, new DefaultCellEditor(field));
</code></pre>

### 解説
上記のサンプルでは、`BorderFactory.createLineBorder(Color.RED, 2)`を設定した`JTextField`を使用する`DefaultCellEditor`を作成し、`JTable#setDefaultEditor(...)`で、`Object.class`のデフォルトエディタとして設定しています。

- - - -
`JTable#setDefaultEditor(...)`を使用せずに、`JTable#prepareEditor(...)`をオーバーライドして、セルエディタとして使用するコンポーネントの背景色や`Border`を変更することもできます。

<pre class="prettyprint"><code>JTable table = new JTable(model) {
  @Override public Component prepareEditor(
      TableCellEditor editor, int row, int column) {
    Component c = super.prepareEditor(editor, row, column);
    if(c instanceof JCheckBox) {
      JCheckBox b = (JCheckBox)c;
      b.setBorderPainted(true);
      b.setBackground(getSelectionBackground());
    }else if(c instanceof JComponent &amp;&amp; convertColumnIndexToModel(column)==1) {
      ((JComponent)c).setBorder(
        BorderFactory.createLineBorder(Color.GREEN, 2));
    }
    return c;
  }
};
</code></pre>

### 参考リンク
- [JTableが使用するBooleanCellEditorの背景色を変更](http://terai.xrea.jp/Swing/BooleanCellEditor.html)

<!-- dummy comment line for breaking list -->

### コメント
