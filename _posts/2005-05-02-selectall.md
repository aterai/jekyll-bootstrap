---
layout: post
category: swing
folder: SelectAll
title: JTextField内のテキストをすべて選択
tags: [JTextField, FocusListener]
author: aterai
pubdate: 2005-05-02T06:05:25+09:00
description: フォーカスがJTextFieldに移動したとき、そのテキストがすべて選択された状態にします。
comments: true
---
## 概要
フォーカスが`JTextField`に移動したとき、そのテキストがすべて選択された状態にします。

{% download https://lh6.googleusercontent.com/_9Z4BYR88imo/TQTSvQx8j-I/AAAAAAAAAjQ/iXgBbTGTGuw/s800/SelectAll.png %}

## サンプルコード
<pre class="prettyprint"><code>textfield.addFocusListener(new FocusAdapter() {
  @Override public void focusGained(FocusEvent e) {
    ((JTextComponent)e.getComponent()).selectAll();
  }
});
</code></pre>

## 解説
上記のサンプルでは、上の`JTextField`にフォーカスが移動したとき、`JTextComponent#selectAll()`メソッドを使って内部のテキストがすべて選択された状態になるようにしています。

## コメント
