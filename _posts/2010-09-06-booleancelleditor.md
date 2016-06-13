---
layout: post
category: swing
folder: BooleanCellEditor
title: JTableが使用するBooleanCellEditorの背景色を変更
tags: [JTable, TableCellEditor, JCheckBox]
author: aterai
pubdate: 2010-09-06T11:51:11+09:00
description: JTableがデフォルトで使用するBooleanCellEditorの背景色を選択色に変更します。
comments: true
---
## 概要
`JTable`がデフォルトで使用する`BooleanCellEditor`の背景色を選択色に変更します。

{% download https://lh5.googleusercontent.com/_9Z4BYR88imo/TQTIJ0rZk-I/AAAAAAAAASU/JvYohArvFpU/s800/BooleanCellEditor.png %}

## サンプルコード
<pre class="prettyprint"><code>JTable table = new JTable(model) {
  @Override public Component prepareEditor(TableCellEditor editor, int row, int column) {
    Component c = super.prepareEditor(editor, row, column);
    if (c instanceof JCheckBox) {
      JCheckBox b = (JCheckBox) c;
      b.setBackground(getSelectionBackground());
      b.setBorderPainted(true);
    }
    return c;
  }
};
</code></pre>

## 解説
- 上: デフォルト
    - セルをクリックして編集状態になると`CellEditor`として、背景色が白の`JCheckBox`が表示される
- 下: `JTable#getSelectionBackground()`
    - `BooleanCellEditor`として使用する`JCheckBox`の背景色が常に`JTable#getSelectionBackground()`になるように`JTable#prepareEditor(...)`をオーバーライド

<!-- dummy comment line for breaking list -->

## コメント
- <kbd>Ctrl</kbd>キーを押しながら選択されている行にある`JCheckBox`をマウスで選択すると、リリースするまで`JCheckBox`の背景色が残っている、`NimbusLookAndFeel`から別の`LookAndFeel`に変更すると選択色が残ってしまうなどの問題に対応しました。 -- *aterai* 2012-02-23 (木) 15:05:20

<!-- dummy comment line for breaking list -->
