---
layout: post
category: swing
folder: LabelForDisplayedMnemonic
title: JLabelに設定したニーモニックでフォーカス移動
tags: [JLabel, JTextField, Mnemonic]
author: aterai
pubdate: 2012-08-20T15:34:19+09:00
description: JLabelにニーモニックを設定し、これに関連付けしたJTextFieldへのフォーカス移動を行います。
image: https://lh4.googleusercontent.com/-c8oDt2QGtY0/UDHQKTuRMGI/AAAAAAAABRQ/dzH-cDi9lEw/s800/LabelForDisplayedMnemonic.png
comments: true
---
## 概要
`JLabel`にニーモニックを設定し、これに関連付けした`JTextField`へのフォーカス移動を行います。

{% download https://lh4.googleusercontent.com/-c8oDt2QGtY0/UDHQKTuRMGI/AAAAAAAABRQ/dzH-cDi9lEw/s800/LabelForDisplayedMnemonic.png %}

## サンプルコード
<pre class="prettyprint"><code>JLabel label = new JLabel("Mail Adress: ");
label.setDisplayedMnemonic('M');
JTextField textField = new JTextField(12);
label.setLabelFor(textField);
</code></pre>

## 解説
上記のサンプルでは、`JLabel`に`setDisplayedMnemonic(...)`メソッドを使って、ニーモニックを設定し、`setLabelFor(...)`メソッドでニーモニックがアクティブになった時にフォーカス移動の対象となるコンポーネントを指定しています。

- 編集不可の`JComboBox`などで、この方法ではフォーカスが移動しない？
    - <kbd>Tab</kbd>キーなどによるフォーカス移動や`JComboBox#requestFocusInWindow()`を実行した場合のようにならない
- [JLabel#setLabelFor(Component) (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/javax/swing/JLabel.html#setLabelFor-java.awt.Component-)
    - 「ニーモニックがアクティブになったときに、`labelFor`プロパティーで指定されているコンポーネントの`requestFocus`メソッドを呼び出します。」
- [JTextComponent#setFocusAccelerator(char) (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/javax/swing/text/JTextComponent.html#setFocusAccelerator-char-)
    - ニーモニックを表示する必要がない場合は、`JTextComponent`などに直接`JTextComponent#setFocusAccelerator(char)`でフォーカスアクセラレータキーを設定することも可能(`JLabel#setLabelFor(Component)`と合わせて設定しても、どちらも有効)

<!-- dummy comment line for breaking list -->

## 参考リンク
- [JLabel#setLabelFor(Component) (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/javax/swing/JLabel.html#setLabelFor-java.awt.Component-)
- [JTextComponent#setFocusAccelerator(char) (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/javax/swing/text/JTextComponent.html#setFocusAccelerator-char-)

<!-- dummy comment line for breaking list -->

## コメント
