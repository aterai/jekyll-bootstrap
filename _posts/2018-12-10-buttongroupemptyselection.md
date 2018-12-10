---
layout: post
category: swing
folder: ButtonGroupEmptySelection
title: ButtonGroup内のボタンが選択されているかを確認する
tags: [ButtonGroup, JToggleButton]
author: aterai
pubdate: 2018-12-10T16:19:43+09:00
description: ButtonGroup内のボタンが1つも選択されていない状態かどうかを確認します。
image: https://drive.google.com/uc?id=1EFXEFMWUlrctxFnVQEQbK1zeW3wSIhoROw
comments: true
---
## 概要
`ButtonGroup`内のボタンが1つも選択されていない状態かどうかを確認します。

{% download https://drive.google.com/uc?id=1EFXEFMWUlrctxFnVQEQbK1zeW3wSIhoROw %}

## サンプルコード
<pre class="prettyprint"><code>button.addActionListener(e -&gt; {
  String txt = Optional.ofNullable(bg.getSelection())
    .map(b -&gt; String.format("\"%s\" isSelected.", b.getActionCommand()))
    .orElse("Please select one of the option above.");
  label.setText(txt);
  // ButtonModel bm = bg.getSelection();
  // if (bm != null) {
  //   label.setText(String.format("\"%s\" isSelected.", bm.getActionCommand()));
  // } else {
  //   label.setText("Please select one of the option above.");
  // }
});
</code></pre>

## 解説
上記のサンプルでは、`ButtonGroup`内のボタンが`1`つも選択されていない状態かどうかを`ButtonModel#getSelection()`メソッドが`null`を返すかどうかで確認しています。

- [ButtonGroup##getSelection() (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/javax/swing/ButtonGroup.html#getSelection--)には、「選択されたボタンのモデルを返します。」と`1`つも選択されていない状態で何が返されるかは記述されていない
    - `ButtonModel`のソースコードではその場合、`null`が返る実装になっている

<!-- dummy comment line for breaking list -->

## 参考リンク
- [ButtonGroup#getSelection() (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/javax/swing/ButtonGroup.html#getSelection--)
- [ButtonGroup中にある選択状態のJToggleButtonをクリックして選択解除可能にする](https://ateraimemo.com/Swing/ToggleButtonGroup.html)
- [ButtonGroup内のJRadioButtonなどの選択をクリア](https://ateraimemo.com/Swing/ClearGroupSelection.html)

<!-- dummy comment line for breaking list -->

## コメント
