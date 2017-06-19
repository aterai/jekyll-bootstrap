---
layout: post
category: swing
folder: SystemColor
title: SystemColorの使用
tags: [SystemColor]
author: aterai
pubdate: 2003-10-20
description: Swingコンポーネントの色をSystemColorクラスから取得します。
image: https://lh4.googleusercontent.com/_9Z4BYR88imo/TQTUESCOFBI/AAAAAAAAAlc/eXW_0wilSew/s800/SystemColor.png
comments: true
---
## 概要
`Swing`コンポーネントの色を`SystemColor`クラスから取得します。

{% download https://lh4.googleusercontent.com/_9Z4BYR88imo/TQTUESCOFBI/AAAAAAAAAlc/eXW_0wilSew/s800/SystemColor.png %}

## サンプルコード
<pre class="prettyprint"><code>Color color = SystemColor.textHighlightText;
</code></pre>

## 解説
各プラットフォームのデスクトップデザインに対応したシステムカラーは、`SystemColor`クラスの`static`フィールドにまとめて定義されています。例えば、`Windows`プラットフォームでデスクトップのカスタマイズでテーマなどを変更すると、この`SystemColor`も動的にその変更に追従します。

- メモ
    - `LookAndFeel`を変更しても`SystemColor`は変化しない
    - `GTKLookAndFeel`がシステムデフォルトになる環境では`SystemColor`を取得することが出来ない

<!-- dummy comment line for breaking list -->

## 参考リンク
- [SystemColor (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/java/awt/SystemColor.html)
- [Color#getColor(...) (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/java/awt/Color.html#getColor-java.lang.String-)

<!-- dummy comment line for breaking list -->

## コメント
