---
layout: post
category: swing
folder: SpinnerNumberModel
title: SpinnerNumberModelに上限値を超える値を入力
tags: [JSpinner, SpinnerNumberModel]
author: aterai
pubdate: 2009-07-13T13:52:46+09:00
description: JSpinnerのテキストフィールドにSpinnerNumberModelが決めた上限値を超える数値を直接入力した後に表示される値をテストします。
image: https://lh3.googleusercontent.com/_9Z4BYR88imo/TQTTrfKZbaI/AAAAAAAAAk0/znT8goHx2Es/s800/SpinnerNumberModel.png
comments: true
---
## 概要
`JSpinner`のテキストフィールドに`SpinnerNumberModel`が決めた上限値を超える数値を直接入力した後に表示される値をテストします。

{% download https://lh3.googleusercontent.com/_9Z4BYR88imo/TQTTrfKZbaI/AAAAAAAAAk0/znT8goHx2Es/s800/SpinnerNumberModel.png %}

## サンプルコード
<pre class="prettyprint"><code>SpinnerNumberModel m1 = new SpinnerNumberModel(
    Integer.MAX_VALUE, 0, Integer.MAX_VALUE, 1);
SpinnerNumberModel m2 = new SpinnerNumberModel(
    Long.valueOf(Integer.MAX_VALUE),
    Long.valueOf(0),
    Long.valueOf(Integer.MAX_VALUE),
    Long.valueOf(1)),
//SpinnerNumberModel m2 = new SpinnerNumberModel(
//    Integer.MAX_VALUE, 0L, Integer.MAX_VALUE, 1L),
</code></pre>

## 解説
- 上: `Byte, Short, Integer, Long`
    - 上限値は上から順に`Byte.MAX_VALUE`、`Short.MAX_VALUE`、`Integer.MAX_VALUE`、`Long.MAX_VALUE`
    - 上限値の先頭に適当な数値を入力すると上限値以外の数値に変換される場合がある
    - `Integer`での例:
    
    		  2_147_483_647 =       0b1111111111111111111111111111111 (Integer.MAX_VALUE)
    		112_147_483_647 = 0b1101000011100100000101100101111111111 (頭に11追加)
    		    478_333_951 =         0b11100100000101100101111111111 (Integer.MAX_VALUEには戻らない)
- 下: `Long.valueOf`
    - 上限値は上と同じ
    - 数値はすべて`Long`
    - 上限値の先頭に適当な数値を入力しても上限値のまま

<!-- dummy comment line for breaking list -->

## 参考リンク
- [SpinnerNumberModel (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/javax/swing/SpinnerNumberModel.html)

<!-- dummy comment line for breaking list -->

## コメント
