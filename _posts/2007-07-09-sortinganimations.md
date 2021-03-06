---
layout: post
category: swing
folder: SortingAnimations
title: JComboBoxのモデルとしてenumを使用する
tags: [JComboBox, Enum, Animation, SwingWorker]
author: aterai
pubdate: 2007-07-09T14:59:22+09:00
description: JComboBoxのモデルとしてenumを使用します。
image: https://lh6.googleusercontent.com/_9Z4BYR88imo/TQTTcZXYeSI/AAAAAAAAAkY/_frjM9wSJsc/s800/SortingAnimations.png
comments: true
---
## 概要
`JComboBox`のモデルとして`enum`を使用します。

{% download https://lh6.googleusercontent.com/_9Z4BYR88imo/TQTTcZXYeSI/AAAAAAAAAkY/_frjM9wSJsc/s800/SortingAnimations.png %}

## サンプルコード
<pre class="prettyprint"><code>private static enum SortAlgorithms {
  Isort    ("Insertion Sort"),
  Selsort  ("Selection Sort"),
  Shellsort("Shell Sort"),
  Hsort    ("Heap Sort"),
  Qsort    ("Quicksort"),
  Qsort2   ("2-way Quicksort");
  private final String description;
  private SortAlgorithms(String description) {
    this.description = description;
  }
  @Override public String toString() {
    return description;
  }
}
JComboBox&lt;SortAlgorithms&gt; algorithmsChoices = new JComboBox&lt;&gt;(SortAlgorithms.values());
</code></pre>

## 解説
`enum`型で`JComboBox`のモデルを作成しています。上記のコードでは、`Enum#toString()`メソッドをオーバーライドして、`JComboBox`の表示はユーザーに分かりやすい名前になるようにしています。

コード中で、どのアイテムが選択されているかなどを調べる場合などは、例えば以下のようにして使用します。

<pre class="prettyprint"><code>switch ((SortAlgorithms) algorithmsChoices.getSelectedItem()) {
  case Isort:     isort(number);         break;
  case Selsort:   ssort(number);         break;
  case Shellsort: shellsort(number);     break;
  case Hsort:     heapsort(number);      break;
  case Qsort:     qsort(0, number - 1);  break;
  case Qsort2:    qsort2(0, number - 1); break;
}
</code></pre>

- - - -
- ソートアニメーション自体は、~~[Sorting Algorithm Animations from Programming Pearls](http://www.cs.bell-labs.com/cm/cs/pearls/sortanim.html)~~のアプレットから基本部分をコピーして`Swing`に移植
    - `SwingWorker`(`JDK 6`以上)を使用したキャンセル機能を追加
    - 全画面の書き換えを止めて、移動する円図形の領域のみウェイトを入れて再描画するように変更

<!-- dummy comment line for breaking list -->

## 参考リンク
- ~~[Sorting Algorithm Animations from Programming Pearls](http://www.cs.bell-labs.com/cm/cs/pearls/sortanim.html)~~
- [Lesson: Performing Custom Painting (The Java™ Tutorials > Creating a GUI With JFC/Swing)](https://docs.oracle.com/javase/tutorial/uiswing/painting/)

<!-- dummy comment line for breaking list -->

## コメント
