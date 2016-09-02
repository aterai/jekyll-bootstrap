---
layout: post
category: swing
folder: CellEditor
title: JTableのセルを編集不可にする
tags: [JTable, TableModel, TableCellEditor]
author: aterai
pubdate: 2004-06-14T05:31:42+09:00
description: JTableのすべてのセルを編集不可にする方法をテストします。
image: https://lh6.googleusercontent.com/_9Z4BYR88imo/TQTIgUbMHLI/AAAAAAAAAS4/v0jIwB26ie4/s800/CellEditor.png
comments: true
---
## 概要
`JTable`のすべてのセルを編集不可にする方法をテストします。

{% download https://lh6.googleusercontent.com/_9Z4BYR88imo/TQTIgUbMHLI/AAAAAAAAAS4/v0jIwB26ie4/s800/CellEditor.png %}

## サンプルコード
<pre class="prettyprint"><code>JTable table = new JTable(new DefaultTableModel() {
  @Override public boolean isCellEditable(int row, int column) {
    return false;
  }
});
</code></pre>

## 解説
上記のサンプルは、以下の三種類の設定で、セルを編集不可にする方法をテストしています。

- `Override TableModel#isCellEditable(...) { return false; }`
    - テーブルモデルの`TableModel#isCellEditable()`メソッドが常に`false`を返すようにオーバーライドして、すべてのセルを編集不可に設定
    - `JTable#isCellEditable()`メソッドをオーバーライドする方法もある
- `JTable#setDefaultEditor(Object.class, null);`
    - 各カラムにセルエディタを設定しない、かつ`Object.class`が使用するデフォルトセルエディタを`null`にすることで、すべてのセルを編集不可にする
        
        <pre class="prettyprint"><code>table.setDefaultEditor(Object.class, null);

</code></pre>
- `JTable#setEnabled(false)`
    - `JTable#setEnabled(false)`で、セルや行の選択なども含めて、すべてのセルでの編集を禁止する
        
        <pre class="prettyprint"><code>table.setEnabled(false);

</code></pre>
    - * 参考リンク [#reference]
- [JTableでキー入力によるセル編集開始を禁止する](http://ateraimemo.com/Swing/PreventStartCellEditing.html)

<!-- dummy comment line for breaking list -->

## コメント
- セルや行の選択をしないのであれば、`JTable#setFocusable(false)`と`JTable#setCellSelectionEnabled(false)`を合わせて利用することでも編集不可にできるようです。こちらは編集不可というより、文字通りフォーカスしないといった感じですが。 -- *shuna* 2009-10-23 (Fri) 03:12:58
    - なるほど。<kbd>F2</kbd>も含めてキー入力で編集開始できなくなる(マウスクリックでは可能？)ようですね。`table.putClientProperty("JTable.autoStartsEdit", Boolean.FALSE);`よりすこし強力といった所でしょうか。いつか、こちらから[JTableでキー入力によるセル編集開始を禁止する](http://ateraimemo.com/Swing/PreventStartCellEditing.html)に移動するかも。 -- *aterai* 2009-10-23 (金) 22:07:44

<!-- dummy comment line for breaking list -->
