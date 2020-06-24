---
layout: post
category: swing
folder: TextFieldActionListener
title: JTextFieldにActionListenerを追加する
tags: [JTextField, ActionListener, JRootPane, DocumentListener]
author: aterai
pubdate: 2017-06-19T14:42:19+09:00
description: JTextFieldにActionListenerを追加して、Enterキーの入力を取得します。
image: https://drive.google.com/uc?id=1JdoY_yKanCFgfCAle83WU8bgTJ7L4E4Cbg
comments: true
---
## 概要
`JTextField`に`ActionListener`を追加して、<kbd>Enter</kbd>キーの入力を取得します。

{% download https://drive.google.com/uc?id=1JdoY_yKanCFgfCAle83WU8bgTJ7L4E4Cbg %}

## サンプルコード
<pre class="prettyprint"><code>JTextField textField2 = new JTextField("addActionListener");
textField2.addActionListener(e -&gt; append(((JTextField) e.getSource()).getText()));
</code></pre>

## 解説
上記のサンプルでは、`JTextField`に`ActionListener`などを追加して<kbd>Enter</kbd>キーを入力した場合の動作をテストしています。

- 上:
    - デフォルトの`JTextField`
    - 自身にフォーカスがあり、かつ親の`JRootPane`に`DefaultButton`が設定されている場合、<kbd>Enter</kbd>キー入力で`DefaultButton`がクリックされる
- 中:
    - `JTextField`のドキュメントに`DocumentListener`を追加
    - `DocumentListener`は<kbd>Enter</kbd>キーの入力には反応しない
    - 自身にフォーカスがあり、かつ親の`JRootPane`に`DefaultButton`が設定されている場合、<kbd>Enter</kbd>キー入力で`DefaultButton`がクリックされる
- 下:
    - `JTextField`に`ActionListener`を追加
    - 親の`JRootPane`に`DefaultButton`が設定されているかどうかに関わらず<kbd>Enter</kbd>キー入力で自身に追加された`ActionListener`が実行される
    - この`ActionListener`はマウスクリックには反応しない

<!-- dummy comment line for breaking list -->

## 参考リンク
- [JTextField#addActionListener(...) (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/javax/swing/JTextField.html#addActionListener-java.awt.event.ActionListener-)

<!-- dummy comment line for breaking list -->

## コメント
