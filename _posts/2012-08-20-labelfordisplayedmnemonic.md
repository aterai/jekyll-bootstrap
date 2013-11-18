---
layout: post
title: JLabelに設定したニーモニックでフォーカス移動
category: swing
folder: LabelForDisplayedMnemonic
tags: [JLabel, JTextField, Mnemonic]
author: aterai
comments: true
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2012-08-20

## JLabelに設定したニーモニックでフォーカス移動
`JLabel`にニーモニックを設定し、これに関連付けした`JTextField`へのフォーカス移動を行います。

{% download %}

![screenshot](https://lh4.googleusercontent.com/-c8oDt2QGtY0/UDHQKTuRMGI/AAAAAAAABRQ/dzH-cDi9lEw/s800/LabelForDisplayedMnemonic.png)

### サンプルコード
<pre class="prettyprint"><code>JLabel label = new JLabel("Mail Adress: ");
label.setDisplayedMnemonic('M');
JTextField textField = new JTextField(12);
label.setLabelFor(textField);
</code></pre>

### 解説
上記のサンプルでは、`JLabel`に`setDisplayedMnemonic(...)`メソッドを使って、ニーモニックを設定し、`setLabelFor(...)`メソッドでニーモニックがアクティブになった時にフォーカス移動の対象となるコンポーネントを指定しています。

- - - -
- 編集不可の`JComboBox`などで、この方法ではフォーカスが移動しない？
    - <kbd>Tab</kbd>キーなどによるフォーカス移動や`JComboBox#requestFocusInWindow()`を実行した場合のようにならない
    - [JLabel#setLabelFor(Component) (Java Platform SE 6)](http://docs.oracle.com/javase/jp/6/api/javax/swing/JLabel.html#setLabelFor%28java.awt.Component%29)
    - 「ニーモニックがアクティブになったときに、`labelFor`プロパティーで指定されているコンポーネントの`requestFocus`メソッドを呼び出します。」
- `JTextComponent`などのフォーカスアクセラレータ: [JTextComponent#setFocusAccelerator(char) (Java Platform SE 6)](http://docs.oracle.com/javase/jp/6/api/javax/swing/text/JTextComponent.html#setFocusAccelerator%28char%29)

<!-- dummy comment line for breaking list -->

### コメント
