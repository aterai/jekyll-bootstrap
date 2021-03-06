---
layout: post
category: swing
folder: TimeFactor
title: JComboBox、JList、JTreeなどの先頭文字列検索に使用するキー入力遅延時間を設定する
tags: [JComboBox, JList, JTree, JFileChooser]
author: aterai
pubdate: 2018-09-03T18:09:59+09:00
description: JComboBox、JList、JTree、JFileChooserの詳細ビューなどで、キー入力による先頭文字列検索に使用する複数キー入力遅延時間を設定します。
image: https://drive.google.com/uc?id=1tAZ74eWWmKaypcoCeBn4AGGjdHlb-j1KiA
comments: true
---
## 概要
`JComboBox`、`JList`、`JTree`、`JFileChooser`の詳細ビューなどで、キー入力による先頭文字列検索に使用する複数キー入力遅延時間を設定します。

{% download https://drive.google.com/uc?id=1tAZ74eWWmKaypcoCeBn4AGGjdHlb-j1KiA %}

## サンプルコード
<pre class="prettyprint"><code>UIManager.put("ComboBox.timeFactor", 1000L);
UIManager.put("List.timeFactor", 1000L);
UIManager.put("Table.timeFactor", 1000L);
UIManager.put("Tree.timeFactor", 1000L);
</code></pre>

## 解説
上記のサンプルでは、`JComboBox`、`JList`、`JTree`、`JFileChooser`の詳細ビュー(`JTable`)で、キー入力による先頭文字検索に使用する複数キー入力遅延時間を設定するテストが実行可能です。

`ComboBox.timeFactor`タブ内の`JSpinner`で遅延時間(ミリ秒)を設定してから`LookAndFeel`を変更(例えば`BasicTreeUI#installDefaults()`メソッドを実行)するとその時間が設定されます。

- `ComboBox.timeFactor`
    - 編集不可の`JComboBox`で先頭文字列検索に使用するキー入力遅延時間を設定可能
    - `JComboBox`のドロップダウンリスト中の`JList`にのみ有効
    - `JFileChooser`内の`JComboBox`には無効(先頭文字列検索自体が無効になっているため)
- `List.timeFactor`
    - `JList`で先頭文字列検索に使用するキー入力遅延時間を設定可能
    - `JFileChooser`内のリストビュー(`JList`)にも有効
- `Table.timeFactor(JFileChooser)`
    - `JFileChooser`内の詳細ビュー(`JTable`)で先頭文字列検索に使用するキー入力遅延時間を設定可能
    - その他の`JTable`には先頭文字列検索自体が存在しない
    - 参考: [JTableで先頭文字のキー入力による検索を行う](https://ateraimemo.com/Swing/TableNextMatchKeyHandler.html)
- `JTree.timeFactor`
    - `JTree`で先頭文字列検索に使用するキー入力遅延時間を設定可能
    - 閉じた状態のノード以下の子要素は検索対象にならない

<!-- dummy comment line for breaking list -->

## 参考リンク
- [JListの先頭文字キー入力による検索選択を無効にする](https://ateraimemo.com/Swing/DisablePrefixMatchSelection.html)
- [JComboBoxでキー入力による項目選択を無効にする](https://ateraimemo.com/Swing/KeySelectionManager.html)
- [JTableで先頭文字のキー入力による検索を行う](https://ateraimemo.com/Swing/TableNextMatchKeyHandler.html)

<!-- dummy comment line for breaking list -->

## コメント
