---
layout: post
title: SpinnerNumberModelに上限値を超える値を入力
category: swing
folder: SpinnerNumberModel
tags: [JSpinner, SpinnerNumberModel]
author: aterai
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2009-07-13

## SpinnerNumberModelに上限値を超える値を入力
`JSpinner`のテキストフィールドに`SpinnerNumberModel`が決めた上限値を超える数値を直接入力した後に表示される値をテストします。

- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](http://lh3.ggpht.com/_9Z4BYR88imo/TQTTrfKZbaI/AAAAAAAAAk0/znT8goHx2Es/s800/SpinnerNumberModel.png)

### サンプルコード
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

### 解説
- `Byte, Short, Integer, Long`(上)
    - 上限値は上から順に`Byte.MAX_VALUE`, `Short.MAX_VALUE`, `Integer.MAX_VALUE`, `Long.MAX_VALUE`
    - 上限値の先頭に適当な数値を入力すると上限値以外の数値に変換される場合がある
    - `Integer`での例:
    
    		  2 147 483 647 =       1111111111111111111111111111111 (Integer.MAX_VALUE)
    		112 147 483 647 = 1101000011100100000101100101111111111 (頭に11追加)
    		    478 333 951 =         11100100000101100101111111111 (Integer.MAX_VALUEには戻らない)
- `Long.valueOf`(下)
    - 上限値は上と同じ
    - 数値はすべて`Long`
    - 上限値の先頭に適当な数値を入力しても上限値のまま

<!-- dummy comment line for breaking list -->

### コメント