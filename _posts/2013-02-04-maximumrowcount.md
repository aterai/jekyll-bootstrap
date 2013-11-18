---
layout: post
title: JComboBoxのドロップダウンリストが表示する最大項目数を設定する
category: swing
folder: MaximumRowCount
tags: [JComboBox, JList]
author: aterai
comments: true
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2013-02-04

## JComboBoxのドロップダウンリストが表示する最大項目数を設定する
`JComboBox`のドロップダウンリストでスクロールバーを使用しないで表示可能な項目数を変更します。

{% download %}

![screenshot](https://lh4.googleusercontent.com/-6YdIN-49R8M/UQ6Cpy8yQdI/AAAAAAAABdE/-6_SS6KCdDE/s800/MaximumRowCount.png)

### サンプルコード
<pre class="prettyprint"><code>comboBox.setMaximumRowCount(newValue);
</code></pre>

### 解説
上記のサンプルでは、`JSpinner`で指定した数値を`JComboBox#setMaximumRowCount(newValue);`で変更することができます。

- 注:
    - デフォルトの`JComboBox`最大表示項目数は、`8`で固定
    - `0`、負の値を設定してもエラーにはならないが、`1`の場合より余分な領域が表示される？

<!-- dummy comment line for breaking list -->

### コメント
