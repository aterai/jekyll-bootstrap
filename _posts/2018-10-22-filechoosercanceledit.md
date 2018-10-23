---
layout: post
category: swing
folder: FileChooserCancelEdit
title: JFileChooserの詳細表示でファイル名が編集中の場合はそれをキャンセルする
tags: [JFileChooser, JTable]
author: aterai
pubdate: 2018-10-22T17:08:54.308+09:00
description: JFileChooserを詳細表示モードで表示したとき、前回のファイル名編集が継続中の場合はそれをキャンセルします。
image: https://drive.google.com/uc?id=1mmE2-oPYGfml1EHlPd7pXonxZxiGUWpelQ
comments: true
---
## 概要
`JFileChooser`を詳細表示モードで表示したとき、前回のファイル名編集が継続中の場合はそれをキャンセルします。

{% download https://drive.google.com/uc?id=1mmE2-oPYGfml1EHlPd7pXonxZxiGUWpelQ %}

## サンプルコード
<pre class="prettyprint"><code>JFileChooser fileChooser1 = new JFileChooser();
JButton button1 = new JButton("removeEditor");
button1.addActionListener(e -&gt; {
  Optional.ofNullable(fileChooser.getActionMap().get("viewTypeDetails"))
    .ifPresent(a -&gt; a.actionPerformed(null));
  stream(fileChooser1)
    .filter(JTable.class::isInstance).map(JTable.class::cast)
    .findFirst()
    .filter(JTable::isEditing).ifPresent(JTable::removeEditor);
  int retvalue = fileChooser1.showOpenDialog(getRootPane());
  if (retvalue == JFileChooser.APPROVE_OPTION) {
    append(log, fileChooser1.getSelectedFile().getAbsolutePath());
  }
});
</code></pre>

## 解説
- `default`
    - `JFileChooser`の詳細表示モード(`JTable`)でファイルをマウスのダブルクリックで選択してダイアログを閉じた場合、次回`JFileChooser`を再表示するとファイル名セルの編集状態が継続している場合がある
    - 再現が不安定？なので、仕様ではなくバグなのかもしれない
- `removeEditor`
    - `JFileChooser`を表示する前に子`JTable`を検索して`JTable#removeEditor()`メソッドを実行し、セルエディタを除去
    - `sun.swing.FilePane#cancelEdit()`メソッドが内部で`detailsTable.getCellEditor().cancelCellEditing();`を実行して編集状態を解除しているが、プライベートなので使用しづらい

<!-- dummy comment line for breaking list -->

## 参考リンク
- [Containerの子Componentを再帰的にすべて取得する](https://ateraimemo.com/Swing/GetComponentsRecursively.html)
- [JTableのセルの編集をコミット](https://ateraimemo.com/Swing/TerminateEdit.html)
    - `JFileChooser`の詳細表示モードで使用する`JTable`に`table.putClientProperty("terminateEditOnFocusLost", Boolean.TRUE);`を設定すれば、フォーカスが無くなった時点で編集は破棄される
- [JFileChooserを編集不可にする](https://ateraimemo.com/Swing/ROFileChooser.html)
    - `JFileChooser`でファイル名を編集する必要がない場合は、`UIManager.put("FileChooser.readOnly", Boolean.TRUE);`と編集不可にすればこの問題は発生しない

<!-- dummy comment line for breaking list -->

## コメント
