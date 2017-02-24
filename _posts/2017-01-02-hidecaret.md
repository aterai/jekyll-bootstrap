---
layout: post
category: swing
folder: HideCaret
title: JTextAreaなどのCaretを非表示にする
tags: [JTextArea, JTextComponent, DefaultCaret, Focus]
author: aterai
pubdate: 2017-01-02T02:13:16+09:00
description: JTextAreaなどのCaretを非表示にするテストを行います。
image: https://drive.google.com/uc?export=view&amp;id=1K6e6fysV1_WfG9uuYpD3nh1eKFVrGTfr6g
comments: true
---
## 概要
`JTextArea`などの`Caret`を非表示にするテストを行います。

{% download https://drive.google.com/uc?export=view&amp;id=1K6e6fysV1_WfG9uuYpD3nh1eKFVrGTfr6g %}

## サンプルコード
<pre class="prettyprint"><code>textArea.setCaret(new DefaultCaret() {
  @Override public boolean isVisible() {
    return false;
  }
});
</code></pre>

## 解説
- `Hide Caret`
    - `DefaultCaret#isVisible()`が常に`false`を返すようにオーバーライドした`Caret`を`JTextArea`に設定することで非表示にする
    - `JTextArea#setCaret(null)`のように`null`を設定すると、`NullPointerException`が発生する
    - `textArea.getCaret().deinstall(textArea)`を実行すると、カーソルキーの移動などで`NullPointerException`が発生する
- `Hide Highlighter`
    - `JTextArea#setHighlighter(null)`のように`null`を設定することで、選択ハイライトを非表示にする
- `Editable`
    - `JTextArea#setEditable(false)`と設定すると、編集不可になり、選択は可能だが`Caret`は非表示になる
- `Editable`
    - `JTextArea#setFocusable(false)`と設定すると、選択不可になり、結果`Caret`も選択ハイライトも非表示になる

<!-- dummy comment line for breaking list -->

## コメント
