---
layout: post
category: swing
folder: Reordering
title: JTableのヘッダ入れ替えを禁止
tags: [JTable, JTableHeader]
author: aterai
pubdate: 2004-05-31T04:43:10+09:00
description: JTableのカラムヘッダをマウスによるドラッグ＆ドロップで並べ替え可能かどうかを切り替えます。
image: https://lh3.googleusercontent.com/_9Z4BYR88imo/TQTRr3AzfQI/AAAAAAAAAhk/mfgsIhuaEz0/s800/Reordering.png
comments: true
---
## 概要
`JTable`のカラムヘッダをマウスによるドラッグ＆ドロップで並べ替え可能かどうかを切り替えます。

{% download https://lh3.googleusercontent.com/_9Z4BYR88imo/TQTRr3AzfQI/AAAAAAAAAhk/mfgsIhuaEz0/s800/Reordering.png %}

## サンプルコード
<pre class="prettyprint"><code>// 列の入れ替えを禁止
table.getTableHeader().setReorderingAllowed(false);
</code></pre>

## 解説
- `JTableHeader#setReorderingAllowed(false)`を設定して、マウスドラッグによる列の入れ替えを禁止
    - `JTable#setDragEnabled(...)`は自動ドラッグ処理用のメソッドで、列の入れ替えには無関係

<!-- dummy comment line for breaking list -->

## 参考リンク
- [JTableHeader#setReorderingAllowed(boolean) (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/javax/swing/table/JTableHeader.html#setReorderingAllowed-boolean-)

<!-- dummy comment line for breaking list -->

## コメント
