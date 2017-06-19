---
layout: post
category: swing
folder: ComboCellEditor
title: JTableのCellEditorにJComboBoxを設定
tags: [JTable, TableCellEditor, JComboBox, TableColumn]
author: aterai
pubdate: 2005-09-26T15:27:12+09:00
description: JTableのCellEditorにJComboBoxを使用し、リストから値を選択できるようにします。
image: https://lh5.googleusercontent.com/_9Z4BYR88imo/TQTJy9xBM6I/AAAAAAAAAU8/h5YELRcY4gE/s800/ComboCellEditor.png
comments: true
---
## 概要
`JTable`の`CellEditor`に`JComboBox`を使用し、リストから値を選択できるようにします。

{% download https://lh5.googleusercontent.com/_9Z4BYR88imo/TQTJy9xBM6I/AAAAAAAAAU8/h5YELRcY4gE/s800/ComboCellEditor.png %}

## サンプルコード
<pre class="prettyprint"><code>JComboBox cb = new JComboBox(new String[] {"名前0", "名前1", "名前2"});
cb.setBorder(BorderFactory.createEmptyBorder());

TableColumn col = table.getColumnModel().getColumn(1);
col.setCellEditor(new DefaultCellEditor(cb));
//col.setCellRenderer(new ComboBoxCellRenderer());
</code></pre>

## 解説
上記のサンプルでは、`1`列目のセルエディタとしてコンボボックスを使う`DefaultCellEditor`を登録しています。

- 注
    - コンボボックスの余白を`0`に設定すれば、セル内にきれいに収納される
        - 参考: [Santhosh Kumar's Weblog : Santhosh Kumar's Weblog](http://www.jroller.com/page/santhosh?entry=tweaking_jtable_editing)
    - 以下は余白を`0`にしていない場合

<!-- dummy comment line for breaking list -->
![screenshot](https://lh3.googleusercontent.com/_9Z4BYR88imo/TQTJ1Ykl--I/AAAAAAAAAVA/ZRLgScHCF3s/s800/ComboCellEditor1.png)

## 参考リンク
- [Santhosh Kumar's Weblog : Santhosh Kumar's Weblog](http://www.jroller.com/page/santhosh?entry=tweaking_jtable_editing)
- [JTableのCellRendererにJComboBoxを設定](http://ateraimemo.com/Swing/ComboCellRenderer.html)
    - セルの表示にも`JComboBox`を使用する場合は、`JComboBox`を継承するセルレンダラーを使用する
- [JComboBoxセルエディタのドロップダウンリストを編集開始直後は表示しないよう設定する](http://ateraimemo.com/Swing/CellEditorTogglePopup.html)

<!-- dummy comment line for breaking list -->

## コメント
