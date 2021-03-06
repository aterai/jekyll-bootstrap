---
layout: post
category: swing
folder: HideCaret
title: JTextAreaなどのCaretを非表示にする
tags: [JTextArea, JTextComponent, DefaultCaret, Focus]
author: aterai
pubdate: 2017-01-02T02:13:16+09:00
description: JTextAreaなどのCaretを非表示にするテストを行います。
image: https://drive.google.com/uc?id=1K6e6fysV1_WfG9uuYpD3nh1eKFVrGTfr6g
comments: true
---
## 概要
`JTextArea`などの`Caret`を非表示にするテストを行います。

{% download https://drive.google.com/uc?id=1K6e6fysV1_WfG9uuYpD3nh1eKFVrGTfr6g %}

## サンプルコード
<pre class="prettyprint"><code>textArea.setCaret(new DefaultCaret() {
  @Override public boolean isVisible() {
    return false;
  }
});
</code></pre>

## 解説
- `Hide Caret`
    - `DefaultCaret#isVisible()`が常に`false`を返すようにオーバーライドした`Caret`を`JTextArea`に設定することで非表示化
    - `JTextArea#setCaret(null)`のように`null`を設定すると、`NullPointerException`が発生する
    - `textArea.getCaret().deinstall(textArea)`を実行すると、カーソルキーの移動などで`NullPointerException`が発生する
- `Hide Highlighter`
    - `JTextArea#setHighlighter(null)`のように`null`を設定して選択ハイライトを非表示にする
- `Editable`
    - `JTextArea#setEditable(false)`を設定すると編集不可になり、選択は可能だが`Caret`は非表示になる
- `Editable`
    - `JTextArea#setFocusable(false)`を設定すると選択不可になり、結果`Caret`も選択ハイライトも非表示になる

<!-- dummy comment line for breaking list -->

## 参考リンク
- [DefaultCaret#isVisible() (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/javax/swing/text/DefaultCaret.html#isVisible--)

<!-- dummy comment line for breaking list -->

## コメント
