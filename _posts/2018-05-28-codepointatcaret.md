---
layout: post
category: swing
folder: CodePointAtCaret
title: JTextArea内にあるCaret位置の文字のUnicodeコードポイントを表示する
tags: [Caret, JTextArea, Font]
author: aterai
pubdate: 2018-05-28T15:48:29+09:00
description: JTextArea内にあるCaretの隣の位置にある文字のUnicodeコードポイントをJTextFieldに表示します。
image: https://drive.google.com/uc?id=1t5jI8FiHF3xA21GNY307MZtNBUX5jP-O1A
hreflang:
    href: https://java-swing-tips.blogspot.com/2020/02/display-unicode-code-point-of-character.html
    lang: en
comments: true
---
## 概要
`JTextArea`内にある`Caret`の隣の位置にある文字の`Unicode`コードポイントを`JTextField`に表示します。

{% download https://drive.google.com/uc?id=1t5jI8FiHF3xA21GNY307MZtNBUX5jP-O1A %}

## サンプルコード
<pre class="prettyprint"><code>String u1F60x = "😀😁😂😃😄😅😆😇😈😉😊😋😌😍😎😏";
String u1F61x = "😐😑😒😓😔😕😖😗😘😙😚😛😜😝😞😟";
String u1F62x = "😠😡😢😣😤😥😦😧😨😩😪😫😬😭😮😯";
String u1F63x = "😰😱😲😳😴😵😶😷😸😹😺😻😼😽😾😿";
String u1F64x = "🙀🙁🙂　　🙅🙆🙇🙈🙉🙊🙋🙌🙍🙎🙏";

JTextField label = new JTextField();
label.setEditable(false);
label.setFont(label.getFont().deriveFont(32f));

List&lt;String&gt; l = Arrays.asList(u1F60x, u1F61x, u1F62x, u1F63x, u1F64x);
JTextArea textArea = new JTextArea(String.join("\n", l));
textArea.addCaretListener(e -&gt; {
  try {
    int dot = e.getDot();
    int mark = e.getMark();
    if (dot - mark == 0) {
      Document doc = textArea.getDocument();
      String txt = doc.getText(dot, 1);
      int code = txt.codePointAt(0);
      if (Character.isHighSurrogate((char) code)) {
        txt = doc.getText(dot, 2);
        code = txt.codePointAt(0);
      }
      label.setText(String.format("%s: U+%04X", txt, code));
    } else {
      label.setText("");
    }
  } catch (BadLocationException ex) {
    ex.printStackTrace();
  }
});
</code></pre>

## 解説
上記のサンプルでは、`JTextArea`に`CaretListener`を設定して`Caret`位置にある文字を取得し、`String#codePointAt(...)`メソッドを使用してその文字の`Unicode`コードポイントを編集不可にした`JTextField`に表示しています。

- `Caret`の位置は、`CaretEvent#getDot()`メソッドで取得
- 文字列選択されている場合(`CaretEvent#getDot() - CaretEvent#getMark() != 0`)はなにも表示しない
- `Caret`の位置の文字は、`JTextArea.getDocument().getText(dot, 1)`で取得しているため、サロゲートペアの場合は`String#codePointAt(...)`でも`Unicode`上位サロゲートコード単位になる
    - `Character.isHighSurrogate(char)`メソッドで`Unicode`上位サロゲートコード単位かを調査し、サロゲートペアの場合は`JTextArea.getDocument().getText(dot, 2)`で取得した文字列の`Unicode`コードポイントを取得する
- `JTextArea.getText().codePointAt(dot)`を使用する場合は、文字列末尾で`StringIndexOutOfBoundsException`が発生するので注意が必要
- `JTextArea`は、カラー絵文字には対応していない

<!-- dummy comment line for breaking list -->

## 参考リンク
- [String#codePointAt(int) (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/java/lang/String.html#codePointAt-int-)
- [Character#isHighSurrogate(char) (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/java/lang/Character.html#isHighSurrogate-char-)
- [JTextComponentでサロゲートペアのテスト](https://ateraimemo.com/Swing/SurrogatePair.html)

<!-- dummy comment line for breaking list -->

## コメント
