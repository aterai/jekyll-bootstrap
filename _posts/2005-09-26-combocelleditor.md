---
layout: post
title: JTableのCellEditorにJComboBoxを設定
category: swing
folder: ComboCellEditor
tags: [JTable, TableCellEditor, JComboBox, TableColumn]
author: aterai
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2005-09-26

## JTableのCellEditorにJComboBoxを設定
`JTable`の`CellEditor`に`JComboBox`を使用し、リストから値を選択できるようにします。

- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](http://lh5.ggpht.com/_9Z4BYR88imo/TQTJy9xBM6I/AAAAAAAAAU8/h5YELRcY4gE/s800/ComboCellEditor.png)

### サンプルコード
<pre class="prettyprint"><code>JComboBox cb = new JComboBox(new String[] {"名前0", "名前1", "名前2"});
cb.setBorder(BorderFactory.createEmptyBorder());

TableColumn col = table.getColumnModel().getColumn(1);
col.setCellEditor(new DefaultCellEditor(cb));
//col.setCellRenderer(new ComboBoxCellRenderer());
</code></pre>

### 解説
上記のサンプルでは、`1`列目のセルエディタとしてコンボボックスを使う`DefaultCellEditor`を登録しています。

- - - -
コンボボックスの余白を`0`にしておくと、セル内にきれいにぴったり収まります(参考:[Santhosh Kumar's Weblog : Santhosh Kumar's Weblog](http://www.jroller.com/page/santhosh?entry=tweaking_jtable_editing))。

- 以下は余白を`0`にしていない場合

<!-- dummy comment line for breaking list -->

![screenshot](http://lh3.ggpht.com/_9Z4BYR88imo/TQTJ1Ykl--I/AAAAAAAAAVA/ZRLgScHCF3s/s800/ComboCellEditor1.png)

- - - -
セルの表示にも`JComboBox`を使用する場合は、[JTableのCellRendererにJComboBoxを設定](http://terai.xrea.jp/Swing/ComboCellRenderer.html)を参考に`JComboBox`を継承するセルレンダラーを使用してみてください。

### 参考リンク
- [JTable Examples](http://www.crionics.com/products/opensource/faq/swing_ex/JTableExamples7.html)
- [Santhosh Kumar's Weblog : Santhosh Kumar's Weblog](http://www.jroller.com/page/santhosh?entry=tweaking_jtable_editing)
- [JTableのCellRendererにJComboBoxを設定](http://terai.xrea.jp/Swing/ComboCellRenderer.html)

<!-- dummy comment line for breaking list -->

### コメント