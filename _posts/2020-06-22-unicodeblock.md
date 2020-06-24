---
layout: post
category: swing
folder: UnicodeBlock
title: JTextArea内の文字の文字種を取得する
tags: [JTextArea, Caret, Character]
author: aterai
pubdate: 2020-06-22T02:43:05+09:00
description: JTextArea内のCaret位置にある文字のUnicodeブロック(文字種)を取得してJTextFieldに表示します。
image: https://drive.google.com/uc?id=1GOMN2Ar0unSeCHDsTEHGWIRcm0DgABQz
comments: true
---
## 概要
`JTextArea`内の`Caret`位置にある文字の`Unicode`ブロック(文字種)を取得して`JTextField`に表示します。

{% download https://drive.google.com/uc?id=1GOMN2Ar0unSeCHDsTEHGWIRcm0DgABQz %}

## サンプルコード
<pre class="prettyprint"><code>JTextArea textArea = new JTextArea("😀😁😂てすとテストＴＥＳＴtest試験、𠮟┷→");
textArea.addCaretListener(e -&gt; {
  try {
    int loc = Math.min(e.getDot(), e.getMark());
    Document doc = textArea.getDocument();
    String txt = doc.getText(loc, 1);
    int code = txt.codePointAt(0);
    if (Character.isHighSurrogate((char) code)) {
      txt = doc.getText(loc, 2);
      code = txt.codePointAt(0);
    }
    Character.UnicodeBlock unicodeBlock = Character.UnicodeBlock.of(code);
    label.setText(String.format("%s: U+%04X", txt, code));
    labelUnicodeBlock.setText(Objects.toString(unicodeBlock));
  } catch (BadLocationException ex) {
    // should never happen
  }
});
</code></pre>

## 解説
上記のサンプルでは、`JTextArea`に`CaretListener`を設定して`Caret`位置、または選択文字列の先頭文字にある文字の`Unicode`コードポイントを取得し、[Character.UnicodeBlock.of(int)](https://docs.oracle.com/javase/jp/8/docs/api/java/lang/Character.UnicodeBlock.html#of-int-)メソッドを使用してその文字種(`Unicode`ブロック)を`JTextField`に表示しています。

- `Unicode`コードポイントの取得は、サロゲートペアに対応
    - 参考: [JTextArea内にあるCaret位置の文字のUnicodeコードポイントを表示する](https://ateraimemo.com/Swing/CodePointAtCaret.html)
- このサンプルでは、`EMOTICONS`、`HIRAGANA`、`KATAKANA`、`HALFWIDTH_AND_FULLWIDTH_FORMS`、`BASIC_LATIN`、`CJK_UNIFIED_IDEOGRAPHS`、`CJK_UNIFIED_IDEOGRAPHS_EXTENSION_B`、`BOX_DRAWING`、`ARROWS`などの文字種が確認可能

<!-- dummy comment line for breaking list -->

## 参考リンク
- [Character.UnicodeBlock (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/java/lang/Character.UnicodeBlock.html)
- [JTextArea内にあるCaret位置の文字のUnicodeコードポイントを表示する](https://ateraimemo.com/Swing/CodePointAtCaret.html)

<!-- dummy comment line for breaking list -->

## コメント
