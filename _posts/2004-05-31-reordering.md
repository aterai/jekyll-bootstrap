---
layout: post
title: JTableのヘッダ入れ替えを禁止
category: swing
folder: Reordering
tags: [JTable, JTableHeader]
author: aterai
comments: true
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2004-05-31

## JTableのヘッダ入れ替えを禁止
ドラッグ＆ドロップでのカラムヘッダ入れ替えを禁止します。

{% download %}

![screenshot](https://lh3.googleusercontent.com/_9Z4BYR88imo/TQTRr3AzfQI/AAAAAAAAAhk/mfgsIhuaEz0/s800/Reordering.png)

### サンプルコード
<pre class="prettyprint"><code>//列の入れ替えを禁止
table.getTableHeader().setReorderingAllowed(false);
</code></pre>

### 解説
`JTableHeader`を取得し、これに`setReorderingAllowed(false)`を指定して、列の入れ替えを禁止します。`JTable#setDragEnabled(...)`は自動ドラッグ処理用のメソッドなので、列の入れ替えには関係ありません。

### コメント
