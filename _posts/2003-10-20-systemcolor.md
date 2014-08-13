---
layout: post
title: SystemColorの使用
category: swing
folder: SystemColor
tags: [SystemColor]
author: aterai
comments: true
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2003-10-20

## SystemColorの使用
`Swing`コンポーネントの色を`SystemColor`クラスから取得します。


{% download https://lh4.googleusercontent.com/_9Z4BYR88imo/TQTUESCOFBI/AAAAAAAAAlc/eXW_0wilSew/s800/SystemColor.png %}

### サンプルコード
<pre class="prettyprint"><code>Color color = SystemColor.textHighlightText;
</code></pre>

### 解説
各プラットフォームのデスクトップデザインに対応したシステムカラーは、`SystemColor`クラスの`static`フィールドにまとめて定義されています。例えば、`Windows`プラットフォームでデスクトップのカスタマイズでテーマなどを変更すると、この`SystemColor`も動的にその変更に追従します(`LookAndFeel`の変更では変化しない)。

### 参考リンク
- [システムカラー](http://www.asahi-net.or.jp/~dp8t-asm/java/tips/SystemColor.html)

<!-- dummy comment line for breaking list -->

### コメント
- `GTK`の環境でその`SystemColor`を取得することは出来ないようです。`UIManager`を使った方がいいかもしれません。 -- [aterai](http://terai.xrea.jp/aterai.html) 2007-05-07 (月) 17:04:59

<!-- dummy comment line for breaking list -->

