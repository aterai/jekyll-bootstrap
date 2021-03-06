---
layout: post
category: swing
folder: CaretSelectionHighlight
title: JTextAreaでのCaretによる選択状態表示を維持する
tags: [JTextArea, Highlighter, Caret, Focus, JTextComponent]
author: aterai
pubdate: 2015-03-16T01:08:13+09:00
description: JTextAreaなどのJTextComponentに、フォーカスがない場合でも文字列の選択状態をハイライト表示するCaretを設定します。
image: https://lh5.googleusercontent.com/-weYSCZJkVwc/VQWpURBqaVI/AAAAAAAAN0U/1vFVeG8fLy4/s800/CaretSelectionHighlight.png
comments: true
---
## 概要
`JTextArea`などの`JTextComponent`に、フォーカスがない場合でも文字列の選択状態をハイライト表示する`Caret`を設定します。

{% download https://lh5.googleusercontent.com/-weYSCZJkVwc/VQWpURBqaVI/AAAAAAAAN0U/1vFVeG8fLy4/s800/CaretSelectionHighlight.png %}

## サンプルコード
<pre class="prettyprint"><code>class FocusCaret extends DefaultCaret {
  DefaultHighlighter.DefaultHighlightPainter nonFocusHighlightPainter
      = new DefaultHighlighter.DefaultHighlightPainter(Color.GRAY.brighter());
  @Override public void focusLost(FocusEvent e) {
    super.focusLost(e);
    setSelectionVisible(true);
  }

  @Override public void focusGained(FocusEvent e) {
    super.focusGained(e);
    setSelectionVisible(false); // removeHighlight
    setSelectionVisible(true); // addHighlight
  }

  @Override protected Highlighter.HighlightPainter getSelectionPainter() {
    return getComponent().hasFocus() ? DefaultHighlighter.DefaultPainter
                                     : nonFocusHighlightPainter;
  }
}
</code></pre>

## 解説
上記のサンプルでは、`JInternalFrame`の選択を切り替えることでその内部の`JTextArea`のフォーカスを変更し、文字列の選択状態ハイライトがどう変化するかをテストしています。

- `DefaultCaret`
    - フォーカスがなくなると、選択状態ハイライトは非表示になる
- `FocusCaret`
    - `DefaultCaret#focusLost(...)`をオーバーライドし、フォーカスがなくなっても`DefaultCaret#setSelectionVisible(true)`を実行して選択状態ハイライトを表示状態に戻す
    - `DefaultCaret#getSelectionPainter()`をオーバーライドし、フォーカスがない場合のハイライト色を変更
    - `DefaultCaret#focusGained(...)`をオーバーライドし、フォーカスがこのキャレットのコンポーネントに移動すると一旦ハイライトを削除してデフォルトのハイライト色を元に戻し、あらためて選択状態ハイライトを表示状態にする

<!-- dummy comment line for breaking list -->

## 参考リンク
- [java - How to retain selected text in JTextField when focus lost? - Stack Overflow](https://stackoverflow.com/questions/18237317/how-to-retain-selected-text-in-jtextfield-when-focus-lost)

<!-- dummy comment line for breaking list -->

## コメント
