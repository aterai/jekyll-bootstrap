---
layout: post
category: swing
folder: DefaultButton
title: DefaultButtonの設定
tags: [JRootPane, JButton, JTextField, Focus]
author: aterai
pubdate: 2008-05-12T14:39:12+09:00
description: DefaultButtonをJRootPaneに設定します。
comments: true
---
## 概要
`DefaultButton`を`JRootPane`に設定します。

{% download https://lh5.googleusercontent.com/_9Z4BYR88imo/TQTKiSOjSTI/AAAAAAAAAWI/e462LXNNrYU/s800/DefaultButton.png %}

## サンプルコード
<pre class="prettyprint"><code>frame.getRootPane().setDefaultButton(button1);
</code></pre>

## 解説
上記のサンプルでは、`JRootPane#setDefaultButton`メソッドを使用して、デフォルトボタンを切り替えています。

- フォーカスが設定したデフォルトボタンにない場合でも、<kbd>Enter</kbd>キーを押したときに起動
    - ただし、ルート区画内に`JTextPane`やフォーカスのある`JButton`などの起動イベントを消費する別のコンポーネントがある場合は除く
        - `JTextField`内にフォーカスがある場合は、<kbd>Enter</kbd>キーを押したときに起動される
        - `JTextArea`内にフォーカスがある場合は、<kbd>Enter</kbd>キーを押しても起動されない(改行が入力される)

<!-- dummy comment line for breaking list -->

- - - -
デフォルトボタンの設定を削除する場合は、`JRootPane#setDefaultButton`に`null`を設定します。

## 参考リンク
- [JRootPane#setDefaultButton(javax.swing.JButton)](http://docs.oracle.com/javase/jp/6/api/javax/swing/JRootPane.html#setDefaultButton%28javax.swing.JButton%29)
- [Windowを開いたときのフォーカスを指定](http://terai.xrea.jp/Swing/DefaultFocus.html)

<!-- dummy comment line for breaking list -->

## コメント
