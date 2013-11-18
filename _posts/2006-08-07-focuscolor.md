---
layout: post
title: JTextFieldにフォーカスがある場合の背景色を設定
category: swing
folder: FocusColor
tags: [JTextField, FocusListener]
author: aterai
comments: true
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2006-08-07

## JTextFieldにフォーカスがある場合の背景色を設定
どの`JTextField`を編集しているのかを分かりやすくするために、フォーカスのある`JTextField`の背景色を変更します。

{% download %}

![screenshot](https://lh6.googleusercontent.com/_9Z4BYR88imo/TQTM__NmYpI/AAAAAAAAAaE/EUMDKR-Rwa4/s800/FocusColor.png)

### サンプルコード
<pre class="prettyprint"><code>private static class BGFocusListener implements FocusListener {
  private final Color dColor;
  private final Color oColor;
  public BGFocusListener(Color oColor, Color dColor) {
    this.dColor = dColor;
    this.oColor = oColor;
  }
  @Override public void focusGained(final FocusEvent e) {
    ((JTextField)e.getSource()).setBackground(dColor);
  }
  @Override public void focusLost(final FocusEvent e) {
    ((JTextField)e.getSource()).setBackground(oColor);
  }
}
</code></pre>

### 解説
`JTextField`に`FocusListener`を追加することで、`focusGained`、`focusLost`した場合にそれぞれ背景色を変更しています。

### コメント
