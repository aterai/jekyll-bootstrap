---
layout: post
category: swing
folder: FocusLostBehavior
title: JFormattedTextFieldからフォーカスが失われた場合の処理を設定する
tags: [JFormattedTextField, Focus]
author: aterai
pubdate: 2017-01-09T03:41:25+09:00
description: JFormattedTextFieldからフォーカスが失われた場合に実行するアクションを設定してテストします。
image: https://drive.google.com/uc?id=1v2TdYvIAIuNFlxDutW3g3476R3mqqff2rQ
comments: true
---
## 概要
`JFormattedTextField`からフォーカスが失われた場合に実行するアクションを設定してテストします。

{% download https://drive.google.com/uc?id=1v2TdYvIAIuNFlxDutW3g3476R3mqqff2rQ %}

## サンプルコード
<pre class="prettyprint"><code>JFormattedTextField ftf = new JFormattedTextField();
try {
  MaskFormatter formatter = new MaskFormatter("UUUUUUUUUU");
  ftf.setFormatterFactory(new DefaultFormatterFactory(formatter));
  ftf.setFocusLostBehavior(JFormattedTextField.COMMIT)
} catch (ParseException ex) {
  ex.printStackTrace();
}
</code></pre>

## 解説
- `JFormattedTextField.COMMIT_OR_REVERT`
    - `JFormattedTextField`のデフォルト
    - フォーカスが失われたとき、正当な値の場合は値を確定し不当な値の場合は前回値に戻す
- `JFormattedTextField.REVERT`
    - フォーカスが失われたとき、常に前回値に戻す
    - 編集を確定するには`JFormattedTextField#commitEdit()`を自前で呼ぶか、`DefaultFormatter#setCommitsOnValidEdit(true)`と設定(文字列が編集されるたびに`commitEdit`が自動的に呼び出される)する必要がある
- `JFormattedTextField.COMMIT`
    - フォーカスが失われたとき、現在の値を確定する
    - 現在の値が正当な値でない場合でも、その値がそのまま残る
- `JFormattedTextField.PERSIST`
    - フォーカスが失われたとき、何も処理しない

<!-- dummy comment line for breaking list -->

## 参考リンク
- [JFormattedTextField (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/javax/swing/JFormattedTextField.html)

<!-- dummy comment line for breaking list -->

## コメント
