---
layout: post
category: swing
folder: MaximumRowCount
title: JComboBoxのドロップダウンリストが表示する最大項目数を設定する
tags: [JComboBox, JList]
author: aterai
pubdate: 2013-02-04T00:43:54+09:00
description: JComboBoxのドロップダウンリストでスクロールバーを使用しないで表示可能な項目数を変更します。
image: https://lh4.googleusercontent.com/-6YdIN-49R8M/UQ6Cpy8yQdI/AAAAAAAABdE/-6_SS6KCdDE/s800/MaximumRowCount.png
comments: true
---
## 概要
`JComboBox`のドロップダウンリストでスクロールバーを使用しないで表示可能な項目数を変更します。

{% download https://lh4.googleusercontent.com/-6YdIN-49R8M/UQ6Cpy8yQdI/AAAAAAAABdE/-6_SS6KCdDE/s800/MaximumRowCount.png %}

## サンプルコード
<pre class="prettyprint"><code>comboBox.setMaximumRowCount(newValue);
</code></pre>

## 解説
上記のサンプルでは、`JSpinner`で指定した数値を`JComboBox#setMaximumRowCount(int)`で設定し、スクロールバーを使用しないでリストに表示できる最大の項目数を変更するテストが実行できます。

- デフォルトの`JComboBox`最大表示項目数は、`LookAndFeel`に依存せず`8`が初期値
- `0`、または負の値を設定してもエラーにはならないが、`1`の場合より余分な領域が表示される場合がある？
- 画面サイズよりリストが大きくなる場合は、末尾のアイテムが表示できなくなる

<!-- dummy comment line for breaking list -->

## 参考リンク
- [JComboBox#setMaximumRowCount(int) (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/javax/swing/JComboBox.html#setMaximumRowCount-int-)

<!-- dummy comment line for breaking list -->

## コメント
