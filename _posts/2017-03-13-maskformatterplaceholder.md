---
layout: post
category: swing
folder: MaskFormatterPlaceholder
title: JFormattedTextFieldにプレースホルダ文字列を追加したMaskFormatterを設定する
tags: [JFormattedTextField, MaskFormatter, FormatterFactory]
author: aterai
pubdate: 2017-03-13T14:44:45+09:00
description: JFormattedTextFieldにプレースホルダ文字やプレースホルダ文字列を追加したMaskFormatterを設定します。
image: https://drive.google.com/uc?id=1jr_CEn9HFdHVL7hiYobxNFuuuVvnlXuyrA
comments: true
---
## 概要
`JFormattedTextField`にプレースホルダ文字やプレースホルダ文字列を追加した`MaskFormatter`を設定します。

{% download https://drive.google.com/uc?id=1jr_CEn9HFdHVL7hiYobxNFuuuVvnlXuyrA %}

## サンプルコード
<pre class="prettyprint"><code>MaskFormatter formatter2 = new MaskFormatter(mask);
formatter2.setPlaceholderCharacter('_');
formatter2.setPlaceholder("000-0000");
field2.setFormatterFactory(new DefaultFormatterFactory(formatter2));
</code></pre>

## 解説
- `new MaskFormatter("###-####")`
    - プレースホルダなしの`MaskFormatter`を設定
- `MaskFormatter#setPlaceholderCharacter('_')`
    - プレースホルダ文字として`_`を設定
- `MaskFormatter#setPlaceholder("000-0000")`
    - プレースホルダ文字として`_`を、プレースホルダ文字列として`000-0000`を設定
    - プレースホルダ文字と違って、プレースホルダ文字列は初回のみ使用される

<!-- dummy comment line for breaking list -->

- - - -
- [JDK-6462028 MaskFormatter API documentation refers to getDisplayValue - Java Bug System](https://bugs.openjdk.java.net/browse/JDK-6462028)
    - [MaskFormatter (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/javax/swing/text/MaskFormatter.html)
    - ドキュメントには`formatter.getDisplayValue(tf, "123");`とのコード例が記述されているが、`MaskFormatter#getDisplayValue(...)`というメソッドは存在しない
- [JFormattedTextField (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/javax/swing/JFormattedTextField.html#JFormattedTextField--)
    - 「特定の型の値を編集するように`JFormattedTextField`を設定する場合は、`setMask`または`setFormatterFactory`を使用してください。」と記述されているが、`JFormattedTextField`に`setMask`というメソッドは存在しない
    - [MaskFormatter#setMask(String)](https://docs.oracle.com/javase/jp/8/docs/api/javax/swing/text/MaskFormatter.html#setMask-java.lang.String-)のことかもしれない

<!-- dummy comment line for breaking list -->

## 参考リンク
- [MaskFormatter (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/javax/swing/text/MaskFormatter.html)
- [JDK-6462028 MaskFormatter API documentation refers to getDisplayValue - Java Bug System](https://bugs.openjdk.java.net/browse/JDK-6462028)

<!-- dummy comment line for breaking list -->

## コメント
