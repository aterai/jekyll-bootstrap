---
layout: post
category: swing
folder: CaretWidth
title: JTextComponentで使用されるCaretの幅を変更する
tags: [Caret, JTextComponent]
author: aterai
pubdate: 2020-07-06T02:13:21+09:00
description: JTextFieldやJTextAreaなどのJTextComponentで使用されるCaretの幅を変更します。
image: https://drive.google.com/uc?id=1yXj9mvzo3Ary_OohlWvmmV2DQXZiSG1O
comments: true
---
## 概要
`JTextField`や`JTextArea`などの`JTextComponent`で使用される`Caret`の幅を変更します。

{% download https://drive.google.com/uc?id=1yXj9mvzo3Ary_OohlWvmmV2DQXZiSG1O %}

## サンプルコード
<pre class="prettyprint"><code>UIManager.put("Caret.width", 2);
JTextField field1 = new JTextField("Caret.width: 2");

JTextField field2 = new JTextField("caretWidth: 4");
field2.putClientProperty("caretWidth", 4);

JTextField field3 = new JTextField("caretAspectRatio: 0.4");
field3.putClientProperty("caretAspectRatio", .4f);
</code></pre>

## 解説
- `Caret.width`
    - `UIManager.put("Caret.width", 2)`を使用してすべての`JTextComponent`で`Caret`の幅を変更
- `caretWidth`
    - `JComponent#putClientProperty("caretWidth", 4)`で指定したコンポーネントの`Caret`の幅を変更
- `caretAspectRatio`
    - `JComponent#putClientProperty("caretAspectRatio", .4f)`で指定したコンポーネントの`Caret`の幅を高さとの比率で変更

<!-- dummy comment line for breaking list -->

- - - -
- `Caret`幅のデフォルトは`1px`
    - `WindowsLookAndFeel`での`Caret`幅のデフォルトはコントロールパネルで指定した幅になる
    - [&#91;JDK-6994562&#93; Swing classes (both JTextArea and JTextField) don't support caret width tuning - Java Bug System](https://bugs.openjdk.java.net/browse/JDK-6994562)
- `Caret`の幅に負の値を設定した場合`1px`に初期化される
- `Caret`の幅を`0px`に設定すると`Caret`が非表示になる
    - [JTextAreaなどのCaretを非表示にする](https://ateraimemo.com/Swing/HideCaret.html)

<!-- dummy comment line for breaking list -->

## 参考リンク
- [&#91;JDK-6994562&#93; Swing classes (both JTextArea and JTextField) don't support caret width tuning - Java Bug System](https://bugs.openjdk.java.net/browse/JDK-6994562)
- [JTextAreaなどのCaretを非表示にする](https://ateraimemo.com/Swing/HideCaret.html)

<!-- dummy comment line for breaking list -->

## コメント
