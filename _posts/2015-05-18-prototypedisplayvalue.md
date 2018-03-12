---
layout: post
category: swing
folder: PrototypeDisplayValue
title: JComboBoxのセルサイズを決定するためのプロトタイプ値を設定する
tags: [JComboBox, ListCellRenderer]
author: aterai
pubdate: 2015-05-18T00:01:40+09:00
description: JComboBoxがそのセルサイズを決定するために使用するプロトタイプ値を設定します。
image: https://lh3.googleusercontent.com/-DafUFitik9w/VVidadY7TNI/AAAAAAAAN4U/D40YKz8mMUY/s800/PrototypeDisplayValue.png
comments: true
---
## 概要
`JComboBox`がそのセルサイズを決定するために使用するプロトタイプ値を設定します。

{% download https://lh3.googleusercontent.com/-DafUFitik9w/VVidadY7TNI/AAAAAAAAN4U/D40YKz8mMUY/s800/PrototypeDisplayValue.png %}

## サンプルコード
<pre class="prettyprint"><code>combo3.setPrototypeDisplayValue(TITLE);
//...
combo5.setRenderer(new SiteListCellRenderer&lt;Site&gt;());
combo5.setPrototypeDisplayValue(new Site(TITLE, new DummyIcon(Color.GRAY)));
</code></pre>

## 解説
1. デフォルト
    - モデルの中からサイズが最大となる要素を検索し、`JComboBox`の推奨サイズを決定する
    - 上記のサンプルでは、モデルが空なのでボタンの幅と余白が`JComboBox`の推奨サイズになっている

<!-- dummy comment line for breaking list -->
1. `JComboBox#setPrototypeDisplayValue(...)`で指定した要素から、`JComboBox`の推奨サイズを決定する
1. 編集可能な場合の`JComboBox`に`JComboBox#setPrototypeDisplayValue(...)`を設定
    - [Bug ID: JDK-6422966 Editable JComboBox.setPrototypeDisplayValue: size can not be smaller than editor](https://bugs.openjdk.java.net/browse/JDK-6422966)

<!-- dummy comment line for breaking list -->
1. 独自の要素`E`を使用する`JComboBox<E>`に、その要素を表示するための`ListCellRenderer<E>`を設定
1. 上記の`JComboBox<E>`に`JComboBox#setPrototypeDisplayValue(E)`でプロトタイプ値を設定
1. 上記の`JComboBox<E>`でモデルを空にして`ListCellRenderer`で値が`null`になる場合、`JComboBox#setPrototypeDisplayValue(E)`で設定した値が表示されてしまう
<pre class="prettyprint"><code>class SiteListCellRenderer&lt;E extends Site&gt; extends JLabel implements ListCellRenderer&lt;E&gt; {
  @Override public Component getListCellRendererComponent(
      JList&lt;? extends E&gt; list, E value, int index, boolean isSelected, boolean cellHasFocus) {
    setOpaque(index &gt;= 0);
    if (Objects.nonNull(value)) {
      setText(value.title);
      setIcon(value.favicon);
    } else {
      //JComboBox#setPrototypeDisplayValue(E)で設定した値が表示されないようにクリア
      setText("");
      setIcon(null);
    }
//...
</code></pre>

## 参考リンク
- [JComboBox#setPrototypeDisplayValue(E) (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/javax/swing/JComboBox.html#setPrototypeDisplayValue-E-)
- [JList#setPrototypeCellValue(E) (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/javax/swing/JList.html#setPrototypeCellValue-E-)
- [JListがJScrollPane内に組み込まれている場合のビューポートサイズを設定する](https://ateraimemo.com/Swing/VisibleListSizeInScrollPane.html)
- [JComboBoxなどの幅をカラム数で指定](https://ateraimemo.com/Swing/SetColumns.html)

<!-- dummy comment line for breaking list -->

## コメント
