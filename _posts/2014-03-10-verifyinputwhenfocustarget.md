---
layout: post
title: InputVerifierを設定したJTextFieldの値が不正な場合のフォーカス移動
category: swing
folder: VerifyInputWhenFocusTarget
tags: [JTextField, InputVerifier, Focus]
author: aterai
comments: true
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2014-03-10

## InputVerifierを設定したJTextFieldの値が不正な場合のフォーカス移動
`InputVerifier`を設定した`JTextField`の値が適切な形式でない場合のフォーカス移動動作をテストします。

{% download %}

![screenshot](https://lh4.googleusercontent.com/-0s6ChUywZz8/Ux0P0IVi99I/AAAAAAAACBY/8hZOhY0SCI4/s800/VerifyInputWhenFocusTarget.png)

### サンプルコード
<pre class="prettyprint"><code>button2.setVerifyInputWhenFocusTarget(false);
</code></pre>

### 解説
上記のサンプルでは、フォーカスが別のコンポーネントに移動する時に、現在フォーカスを持つコンポーネントの`InputVerifier`で値を検証するかを

- `Default`:
    - `JBUtton`のデフォルトで、`getVerifyInputWhenFocusTarget()`が`true`、`isFocusable()`も`true`
    - すべての`JTextField`の値をクリアし、自身にフォーカスが移動するが、フォーカスのあった`JTextField`に入力されている値が`Integer`でない場合、警告音が鳴る
- `setFocusable(false)`:
    - `setFocusable(false)`を設定
    - すべての`JTextField`の値をクリアするが、フォーカスは移動しないため、フォーカスのあった`JTextField`に入力されている値が`Integer`でない場合でも、警告音は鳴らない(設定されている`InputVerifier#verify(...)`は呼ばれない)
- `setVerifyInputWhenFocusTarget(false)`:
    - `setVerifyInputWhenFocusTarget(false)`を設定
    - すべての`JTextField`の値をクリアし、自身にフォーカスが移動するが、フォーカスのあった`JTextField`に入力されている値が`Integer`でない場合でも、警告音は鳴らない(設定されている`InputVerifier#verify(...)`は呼ばれない)

<!-- dummy comment line for breaking list -->

### 参考リンク
- [入力の検証](http://docs.oracle.com/javase/jp/1.4/guide/swing/1.3/InputChanges.html)

<!-- dummy comment line for breaking list -->

### コメント