---
layout: post
category: swing
folder: BitSetCheckBoxes
title: JCheckBoxの選択状態をBitSetで管理する
tags: [JCheckBox, BitSet, UndoManager, UndoableEditSupport]
author: aterai
pubdate: 2018-03-26T16:22:10+09:00
description: 複数のJCheckBoxの選択状態をBitSetを使用して管理します。
image: https://drive.google.com/uc?id=1u_RLXjvLSINB0mb0ar_COqlBq5jbVhPByg
comments: true
---
## 概要
複数の`JCheckBox`の選択状態を`BitSet`を使用して管理します。

{% download https://drive.google.com/uc?id=1u_RLXjvLSINB0mb0ar_COqlBq5jbVhPByg %}

## サンプルコード
<pre class="prettyprint"><code>// Long.MAX_VALUE
// 0b111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111
// protected static final int BIT_LENGTH = 63;
protected static final int BIT_LENGTH = 72;
BitSet status = BitSet.valueOf(new long[] {Long.valueOf("111000111", 2)});
// ...
IntStream.range(0, BIT_LENGTH).forEach(i -&gt; {
  JCheckBox c = new JCheckBox(Integer.toString(i), status.get(i));
  c.addActionListener(e -&gt; {
    JCheckBox cb = (JCheckBox) e.getSource();
    BitSet newValue = status.get(0, BIT_LENGTH);
    newValue.set(i, cb.isSelected());
    undoSupport.postEdit(new StatusEdit(status, newValue));
    status = newValue;
    label.setText(print(status));
  });
panel.add(c);
});
</code></pre>

## 解説
- `JCheckBox`の選択状態を`BitSet`で管理
- `UndoManager`を使用したアンドゥ・リドゥは、[JCheckBoxの選択状態をBigIntegerで記憶し、UndoManagerを使用して元に戻したりやり直したりする](https://ateraimemo.com/Swing/UndoRedoCheckBoxes.html)と同じ
- `JCheckBox`がクリックされて値が変化した場合、`BitSet`内のビットを`2`進数の形で表示
    - `BitSet#toLongArray()`を使用しているので、`Long.MAX_VALUE`より`2`進数での桁数が大きくなる場合は注意が必要
    - `BitSet#toLongArray()`が返す`long`配列は、`0`から`63`ビットが存在すればインデックス`0`、`64`から`127`ビットが存在すればインデックス`1`と続く
        - 参考: [java - BitSet toString() and valueOf() are difficult to understand - Stack Overflow](https://stackoverflow.com/questions/37170363/bitset-tostring-and-valueof-are-difficult-to-understand)
    - `BitSet`内のビットが全て空の場合、`bitSet.toLongArray().length`は`0`となり、`bitSet.toLongArray()[0]`は`ArrayIndexOutOfBoundsException`になる
    - `bitSet.toLongArray()[0]`に`0`から`63`ビットのすべてにフラグが立った`Long`値`lv`が入っている場合、符号ビットにもフラグが立った状態なので`Long.toString(lv, 2)`は`-1`になる
        - 符号なし整数として扱うよう`Long.toUnsignedString(lv, 2)`を使用する必要がある

<!-- dummy comment line for breaking list -->

<pre class="prettyprint"><code>// 0 から 63 ビットのすべてにフラグがある場合、bitSet.toLongArray()[0] には、
// 0b1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111
// が入っている
private static String print(BitSet bitSet) {
  StringBuilder buf = new StringBuilder();
  for (long lv: bitSet.toLongArray()) {
    buf.insert(0, Long.toUnsignedString(lv, 2));
  }
  String b = buf.toString();
  int count = bitSet.cardinality();
  return "&lt;html&gt;0b" + ZEROPAD.substring(b.length()) + b + "&lt;br/&gt; count: " + count;
}
</code></pre>

## 参考リンク
- [BitSet (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/java/util/BitSet.html)
- [JCheckBoxの選択状態をBigIntegerで記憶し、UndoManagerを使用して元に戻したりやり直したりする](https://ateraimemo.com/Swing/UndoRedoCheckBoxes.html)
    - `BigInteger`を使用する場合のサンプル
- [java - BitSet toString() and valueOf() are difficult to understand - Stack Overflow](https://stackoverflow.com/questions/37170363/bitset-tostring-and-valueof-are-difficult-to-understand)
- [Long#toUnsignedString(...) (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/java/lang/Long.html#toUnsignedString-long-int-)
    - `JDK 1.8.0`で符号なし整数として扱うために追加された

<!-- dummy comment line for breaking list -->

## コメント
