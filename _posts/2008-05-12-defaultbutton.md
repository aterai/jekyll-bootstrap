---
layout: post
category: swing
folder: DefaultButton
title: DefaultButtonの設定
tags: [JRootPane, JButton, JTextField, Focus]
author: aterai
pubdate: 2008-05-12T14:39:12+09:00
description: 自身の親となるJRootPaneを取得し、これにEnterキー入力で起動するデフォルトのJButtonを設定します。
image: https://lh5.googleusercontent.com/_9Z4BYR88imo/TQTKiSOjSTI/AAAAAAAAAWI/e462LXNNrYU/s800/DefaultButton.png
comments: true
---
## 概要
自身の親となる`JRootPane`を取得し、これに<kbd>Enter</kbd>キー入力で起動するデフォルトの`JButton`を設定します。

{% download https://lh5.googleusercontent.com/_9Z4BYR88imo/TQTKiSOjSTI/AAAAAAAAAWI/e462LXNNrYU/s800/DefaultButton.png %}

## サンプルコード
<pre class="prettyprint"><code>button1.getRootPane().setDefaultButton(button1);
</code></pre>

## 解説
上記のサンプルでは、`JRootPane#setDefaultButton()`メソッドを使用して、デフォルトボタンを切り替えています。

- フォーカスが設定したデフォルトボタンにない場合でも、<kbd>Enter</kbd>キーを押したときに起動する
    - ただし、ルート区画内に`JTextPane`やフォーカスのある`JButton`などの起動イベントを消費する別のコンポーネントがある場合は除く
        - `JTextField`内にフォーカスがある場合は、<kbd>Enter</kbd>キーを押したときに起動する
        - `JTextArea`内にフォーカスがある場合は、<kbd>Enter</kbd>キーを押しても起動しない(改行が入力される)
- デフォルトボタンの設定を削除する場合は、`JRootPane#setDefaultButton(null)`を使用する

<!-- dummy comment line for breaking list -->

## 参考リンク
- [JRootPane#setDefaultButton(JButton) (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/javax/swing/JRootPane.html#setDefaultButton-javax.swing.JButton-)
- [Windowを開いたときのフォーカスを指定](https://ateraimemo.com/Swing/DefaultFocus.html)
- [DefaultButtonをフォーカスが存在するJButtonに設定する](https://ateraimemo.com/Swing/DefaultButtonFollowsFocus.html)

<!-- dummy comment line for breaking list -->

## コメント
