---
layout: post
category: swing
folder: SmyliyIconStyle
title: JTextPaneに入力した文字をアイコンに変換する
tags: [JTextPane, Icon, StyledDocument, StyleContext]
author: aterai
pubdate: 2015-09-14T03:54:53+09:00
description: JTextPaneに入力した文字を顔文字アイコンに変換して表示します。
image: https://lh3.googleusercontent.com/-NLmesRy01ro/VfXFpQeOQSI/AAAAAAAAOBo/L7P-9nfFeNk/s800-Ic42/SmyliyIconStyle.png
comments: true
---
## 概要
`JTextPane`に入力した文字を顔文字アイコンに変換して表示します。

{% download https://lh3.googleusercontent.com/-NLmesRy01ro/VfXFpQeOQSI/AAAAAAAAOBo/L7P-9nfFeNk/s800-Ic42/SmyliyIconStyle.png %}

## サンプルコード
<pre class="prettyprint"><code>private void update(DefaultStyledDocument doc, int offset) {
  final Element elm = doc.getCharacterElement(offset);
  EventQueue.invokeLater(new Runnable() {
    @Override public void run() {
      try {
        int start = elm.getStartOffset();
        int end = elm.getEndOffset();
        System.out.format("start: %d, end: %d%n", start, end);
        String text = doc.getText(start, end - start);
        int pos = text.indexOf(FACE);
        while (pos &gt; -1) {
          Style face = doc.getStyle(FACE);
          doc.setCharacterAttributes(start + pos, FACE.length(), face, false);
          pos = text.indexOf(FACE, pos + FACE.length());
        }
      } catch (BadLocationException ex) {
        ex.printStackTrace();
      }
    }
  });
}
</code></pre>

## 解説
上記のサンプルでは、`StyleConstants.setIcon(doc.addStyle(":)", null), new FaceIcon())`でドキュメントにアイコン属性を設定し、文字列の追加、削除が実行されると、文字列から`:)`を検索し、見つけた文字列に対して`StyledDocument#setCharacterAttributes(...)`でそのアイコン属性を適用しています。

- 制限:
    - `:)`から一文字削除してもアイコンが解除されない
- メモ:
    - 顔文字の検索範囲を`StyledDocument#getCharacterElement(offset)`で取得した`Element`に限定することで高速化
        - `LabelView`を継承する`View`にしたほうが速いかもしれない
    - スタイルにアイコン属性だけでなく、文字色属性などを追加する場合、`MutableAttributeSet inputAttributes = textPane.getInputAttributes();inputAttributes.removeAttributes(inputAttributes)`などを実行して、後続の入力文字列に属性が引き継がれないようにする必要がある？
        
        <pre class="prettyprint"><code>Style def = StyleContext.getDefaultStyleContext()
                                .getStyle(StyleContext.DEFAULT_STYLE);
        Style face = doc.addStyle(FACE, def);
        StyleConstants.setIcon(face, new FaceIcon());
        StyleConstants.setForeground(face, Color.RED);
</code></pre>
    - * 参考リンク [#reference]
- [Replacing text in JTextPane with an image (think smileys) | Oracle Community](https://community.oracle.com/message/5853611)

<!-- dummy comment line for breaking list -->

## コメント
